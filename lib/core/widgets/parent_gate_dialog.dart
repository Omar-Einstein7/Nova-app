import "dart:math";
import "package:flutter/material.dart";
import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";
import "app_text_field.dart";

/// Shows a simple arithmetic gate to verify the parent is interacting.
/// Numbers are randomly generated in the range [5, 9].
/// Returns [true] if the answer is correct, [false] / [null] otherwise.
Future<bool> showParentGate(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _ParentGateDialog(),
  );
  return result ?? false;
}

class _ParentGateDialog extends StatefulWidget {
  const _ParentGateDialog();

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  late final int _a;
  late final int _b;
  late final int _answer;
  final _controller = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _a = rng.nextInt(5) + 5; // [5, 9]
    _b = rng.nextInt(5) + 5;
    _answer = _a + _b;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final entered = int.tryParse(_controller.text.trim());
    if (entered == _answer) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _hasError = true);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "تحقق من هوية ولي الأمر",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "كم يساوي $_a + $_b؟",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: "أدخل الإجابة",
            controller: _controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              if (_hasError) setState(() => _hasError = false);
            },
          ),
          if (_hasError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              "إجابة غير صحيحة، حاول مرة أخرى.",
              style: TextStyle(
                color: AppColors.gentleRetry,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("تأكيد"),
        ),
      ],
    );
  }
}

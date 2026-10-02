import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Terms + Privacy notice shown at the bottom of auth forms.
/// [PLACEHOLDER: replace termsUrl and privacyUrl with real URLs]
class AuthTermsFooter extends StatelessWidget {
  const AuthTermsFooter({super.key});

  // [PLACEHOLDER: terms URL]
  static const String _termsUrl = 'https://example.com/terms';

  // [PLACEHOLDER: privacy URL]
  static const String _privacyUrl = 'https://example.com/privacy';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textSecondary,
        );
    final linkStyle = textStyle?.copyWith(
      color: AppColors.primary,
      decoration: TextDecoration.underline,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          style: textStyle,
          children: [
            TextSpan(text: l10n.registerTermsPrefix),
            TextSpan(
              text: l10n.registerTermsLink,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // [PLACEHOLDER: open _termsUrl with url_launcher]
                  debugPrint('Open: $_termsUrl');
                },
            ),
            TextSpan(text: l10n.registerTermsAnd),
            TextSpan(
              text: l10n.registerPrivacyLink,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // [PLACEHOLDER: open _privacyUrl with url_launcher]
                  debugPrint('Open: $_privacyUrl');
                },
            ),
          ],
        ),
      ),
    );
  }
}

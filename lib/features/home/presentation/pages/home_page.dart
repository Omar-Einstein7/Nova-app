import "package:flutter/material.dart";
import "../../../../core/theme/theme.dart";
/// Placeholder home page – will be expanded in later phases.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("نوفا 🌟")),
      body: const Center(
        child: Text(
          "مرحباً بك في نوفا 🎉",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

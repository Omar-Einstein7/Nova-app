import "package:flutter/material.dart";
class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.childId});
  final String childId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("التقدم — $childId — قريباً")));
}

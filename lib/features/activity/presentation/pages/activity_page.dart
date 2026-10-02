import "package:flutter/material.dart";
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.extra});
  final Map<String, dynamic> extra;
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("النشاط — قريباً")));
}

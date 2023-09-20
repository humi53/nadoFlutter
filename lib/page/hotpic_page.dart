import 'package:flutter/material.dart';

class HotpicPage extends StatefulWidget {
  const HotpicPage({super.key});

  @override
  State<HotpicPage> createState() => _HotpicPageState();
}

class _HotpicPageState extends State<HotpicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이번주의 작품들"),
      ),
      body: const Text("이번주의 작품들"),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:route_88/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeAppBarTitle)),
      body: const Center(
        child: Text('Welcome to Route 88'),
      ),
    );
  }
}

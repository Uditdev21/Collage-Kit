import 'package:collagekit/Home/PageDrawer.dart';
import 'package:flutter/material.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Pagedrawer(),
      appBar: AppBar(
        title: Text('settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [Text('Setting 1')],
        ),
      ),
    );
  }
}

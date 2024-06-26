import 'package:collagekit/Home/PageDrawer.dart';
import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
      ),
      drawer: Pagedrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Text("this app is created by collage-Kit"),
      ),
    );
  }
}

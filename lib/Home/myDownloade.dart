import 'package:collagekit/Home/PageDrawer.dart';
import 'package:flutter/material.dart';

class Mydownloades extends StatefulWidget {
  const Mydownloades({super.key});

  @override
  State<Mydownloades> createState() => _MydownloadesState();
}

class _MydownloadesState extends State<Mydownloades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Downloades"),
      ),
      drawer: Pagedrawer(),
    );
  }
}

//under development for the next version for offline access

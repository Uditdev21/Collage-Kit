import 'package:collagekit/Home/PageDrawer.dart';
import 'package:flutter/material.dart';

class Myuploades extends StatefulWidget {
  const Myuploades({super.key});

  @override
  State<Myuploades> createState() => _MyuploadesState();
}

class _MyuploadesState extends State<Myuploades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY UPLOADES"),
      ),
      drawer: Pagedrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: OrientationBuilder(builder: (context, orientation) {
          return const Text(
              "this page underdevelopment please wait for the future updates loram ipsum ");
        }),
      ),
    );
  }
}

import 'package:collagekit/Home/PageDrawer.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  authServices authservices = authServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
        ),
        drawer: Pagedrawer(),
        body: OrientationBuilder(builder: (context, Orientation) {
          return Center(
              child: Text('${authservices.CurrentUser!.displayName}'));
        }));
  }
}

import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/Home/HomePage.dart';
import 'package:collagekit/Home/UploadeNotes.dart';
import 'package:collagekit/Home/aboutUs.dart';
import 'package:collagekit/Home/myUploades.dart';
import 'package:collagekit/Home/settings.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:flutter/material.dart';

class Pagedrawer extends StatefulWidget {
  const Pagedrawer({super.key});

  @override
  State<Pagedrawer> createState() => _PagedrawerState();
}

class _PagedrawerState extends State<Pagedrawer> {
  authServices authservices = authServices();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(83, 86, 255, 1),
            ),
            child: Center(
                child:
                    Text('Collage-Kit', style: TextStyle(color: Colors.white))),
          ),
          ListTile(
            leading: Icon(Icons.home), // Add icons here
            title: Text('home'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Homepage()),
                (Route<dynamic> route) => false, // Remove all existing routes
              );
            },
          ),
          //underDevopment for offline access

          // ListTile(
          //   leading: Icon(Icons.picture_as_pdf),
          //   title: Text('My Downloades'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => Mydownloades()),
          //     );
          //     // Handle settings item tap.
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.upload),
            title: Text('Uploade Notes'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Uploadenotes()),
                (Route<dynamic> route) => false, // Remove all existing routes
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.my_library_add),
            title: Text('my uploades'),
            onTap: () async {
              try {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Myuploades()),
                );
              } catch (e) {}
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => settings()),
              );
              // Handle settings item tap.
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('About Us'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Aboutus()),
                (Route<dynamic> route) => false, // Remove all existing routes
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              try {
                await authservices.singout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              } catch (e) {}
            },
          ),
          // Add more styled menu items as needed.
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/homepage.dart';
import 'package:point_plotter/login.dart';
import 'package:point_plotter/results.dart';

class DrawerContent extends StatefulWidget {
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final auth = FirebaseAuth.instance;
  Widget tiles(String name, IconData icon, Function function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton.icon(
            onPressed: function,
            icon: Icon(icon, color: Colors.grey[700]),
            label: Text(
              name,
              style: TextStyle(color: Colors.grey[700]),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          tiles(
              'Home',
              Icons.home,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage()))),
          tiles(
              'Log out',
              Icons.logout,
              () => {
                    auth.signOut(),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                  })
        ],
      ),
    );
  }
}

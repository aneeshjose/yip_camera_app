import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/camera.dart';
import 'package:point_plotter/coordinate_adjust.dart';
import 'package:point_plotter/drawer.dart';
import 'package:point_plotter/left_side_camera.dart';
import 'package:point_plotter/right_side_camera.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _userResults;

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    // List<>
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("SizeMe"),
      ),
      drawer: Drawer(child: DrawerContent()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.photo_camera_outlined),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeftCamera(),
          ),
        ),
      ),
      body: (_userResults != null && _userResults.length == 0)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You haven\'t uploaded any photos yet or are awaiting to get processed',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoordinatePlotter(
                              url: _userResults[index].data()['url']))),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: CachedNetworkImage(
                        imageUrl: _userResults[index].data()['url'],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _userResults?.length ?? 0,
            ),
    );
  }

  getResults() {
    FirebaseFirestore.instance
        .collection('coordinates')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        _userResults = event.docs;
      });
    });
  }
}

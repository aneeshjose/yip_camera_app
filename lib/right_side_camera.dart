import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:point_plotter/camera_utils.dart';
import 'package:point_plotter/left_side_camera.dart';

class RightCamera extends StatefulWidget {
  @override
  _RightCameraState createState() => _RightCameraState();
}

class _RightCameraState extends State<RightCamera> {
  String focalLength = "";
  CountDownController _controller = CountDownController();
  CameraController controller;
  int _duration = 2;
  XFile imageFile;

  bool _fileUploading = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    controller.initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Camera02");
    print("--------------------------");
    if (!controller.value.isInitialized) {
      return Container();
    }

    return SafeArea(
      child: Scaffold(
        body: _fileUploading
            ? Center(
                child: Text('File uploading.  Please wait'),
              )
            : Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  CameraPreview(
                    controller,
                    child: ClipPath(
                      clipper: MyCustomClipper(context),
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   color: Colors.black,
                  //   child: ClipPath(
                  //     clipper: MyCustomClipper(context),
                  //     child: Opacity(
                  //       opacity: 0.7,
                  //       child: Container(
                  //         color: Colors.grey[800],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  if (_fileUploading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 120.0,
                      padding: EdgeInsets.all(20.0),
                      color: Color.fromRGBO(00, 00, 00, 0.7),
                      child: Stack(
                        children: <Widget>[
                          InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: Center(
                                child: CircularCountDownTimer(
                                  duration: _duration,
                                  initialDuration: 0,
                                  controller: _controller,
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  ringColor: Colors.grey[300],
                                  ringGradient: null,
                                  fillColor: Colors.grey[100],
                                  fillGradient: null,
                                  backgroundColor: Colors.black12,
                                  backgroundGradient: null,
                                  strokeWidth: 10.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: TextStyle(
                                      fontSize: 50.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: true,
                                  isReverseAnimation: false,
                                  isTimerTextShown: true,
                                  autoStart: false,
                                  onComplete: () {
                                    takePicture().then((XFile file) async {
                                      if (mounted) {
                                        setState(() {
                                          imageFile = file;
                                        });
                                        if (file != null) {
                                          _uploadFile(context);
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _controller.start(),
          backgroundColor: Colors.white,
          child: Text(
            'Start',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }

  Future<XFile> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      XFile file = await cameraController?.takePicture();
      return file;
    } on CameraException catch (_) {
      return null;
    }
  }

  Future _uploadFile(BuildContext context) async {
    if (imageFile == null) return;
    final fileName = basename(imageFile.path);
    File file = File(imageFile.path);
    final destination =
        '${FirebaseAuth.instance.currentUser?.uid ?? DateTime.now().millisecondsSinceEpoch}/$fileName';
    setState(() {
      _fileUploading = true;
    });

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(file)
        .whenComplete(() => print('hello'));

    String downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('Images').add({
      'userid': FirebaseAuth.instance.currentUser?.uid,
      'url': downloadUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Uploaded successfully. Now turn to left",
      ),
    ));

    setState(() {
      _fileUploading = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LeftCamera()));
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final BuildContext context;
  MyCustomClipper(this.context);

  @override
  Path getClip(Size size) {
    Path border;

    // left border
    border = Path()
      ..addRect(Rect.fromLTRB(
          0, 0, getWidthFromPercentage(5), getHeightFromPercentage(100)));
    // right border
    border.addPath(border, Offset(getWidthFromPercentage(95), 0));

    Path spaceBeforeHead = Path()
      ..addRect(Rect.fromLTRB(
          0, 0, getWidthFromPercentage(60), getHeightFromPercentage(13)));
    border.addPath(spaceBeforeHead, Offset(getWidthFromPercentage(5), 0));

    Path spaceUnderHands = Path()
      ..addRect(Rect.fromLTRB(
          0, 0, getWidthFromPercentage(60), getHeightFromPercentage(80)));

    border.addPath(spaceUnderHands,
        Offset(getWidthFromPercentage(5), getHeightFromPercentage(22)));

    return border;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  double getWidthFromPercentage(int percentage) {
    double width = MediaQuery.of(context).size.width;
    return percentage * width / 100;
  }

  double getHeightFromPercentage(int percentage) {
    double height = MediaQuery.of(context).size.height;
    return percentage * height / 100;
  }
}

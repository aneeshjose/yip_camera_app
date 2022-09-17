import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:point_plotter/camera_utils.dart';
import 'package:point_plotter/right_side_camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String focalLength = "";
  CountDownController _controller = CountDownController();
  int _duration = 2;
  XFile imageFile;

  bool _fileUploading = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      XFile file = await cameraController.takePicture();
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
    // downloadUrl =
    //     'https://firebasestorage.googleapis.com/v0/b/size-me.appspot.com/o/sample3.jpg?alt=media&token=3ad2fd3b-a70f-409d-93c0-469a0f7b366c';
    // Response resp = await post(Uri.parse('http://35.193.86.253:5000'),
    //     headers: {'Content-type': 'applications/json'},
    //     body: json.encode({
    //       'url': downloadUrl,
    //     }));
    // Map respMap = json.decode(resp.body);
    // num totalPixels = respMap['totalpixels'];
    // int width = respMap['width'];
    // int height = respMap['height'];
    // respMap.removeWhere((key, value) => key == 'totalpixels');
    // respMap.removeWhere((key, value) => key == 'width');
    // respMap.removeWhere((key, value) => key == 'height');
    // await FirebaseFirestore.instance.collection('coordinates').add({
    //   'uid': FirebaseAuth.instance.currentUser.uid,
    //   'url': downloadUrl,
    //   'height_pixels': totalPixels,
    //   'coordinates': respMap,
    //   'width': double.parse(width.toString()),
    //   'height': double.parse(height.toString()),
    // });
    // print(respMap);

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     "Uploaded successfully. The results will be sent to your homepage shortly",
    //   ),
    // ));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Uploaded successfully. Now turn to right",
      ),
    ));

    setState(() {
      _fileUploading = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RightCamera()));
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final BuildContext context;
  MyCustomClipper(this.context);

  @override
  Path getClip(Size size) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Path border;

    // left border
    border = Path()..addRect(Rect.fromLTRB(0, 0, width / 20.5, height));
    // right border
    border.addPath(border, Offset(width / 1.05, 0));

    Path leftLeg = Path()
      ..addRect(Rect.fromLTRB(width / 41, height / 3.5, width / 4.1, height));

    // border at left hand bottom
    border.addPath(leftLeg, Offset(width / 42, 0));
    // border at right hand bottom
    border.addPath(leftLeg, Offset(width - width / 3.43, 0));

    Path leftHand = Path()
      ..addRect(Rect.fromLTRB(width / 40, 0, width / 4.1, height / 4.5));

    // left hand
    border.addPath(leftHand, Offset(width / 7, 0));

    // right hand
    border.addPath(leftHand, Offset(width / 1.708, 0));

    Path hatCut = Path()
      ..addPolygon([
        Offset(width / 2 - width / 8, 0),
        Offset(width / 2 + width / 9, 0),
        Offset(width / 2 + width / 9, height / 9),
        Offset(width / 2 - width / 8, height / 9),
      ], true);
    border.addPath(hatCut, Offset(0, 0));

    Path centerCut = Path()
      ..addPolygon([
        Offset(width / 2 - width / 9, height / 2),
        Offset(width / 2 + width / 9, height / 2),
        Offset(width / 2, height / 2 - height / 2.5),
      ], true);
    border.addPath(centerCut, Offset(0, height / 2.3));

    return border;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

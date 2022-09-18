import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/plotted_lines.dart';
import 'package:point_plotter/plotted_points.dart';
import 'package:point_plotter/acquire_height.dart';

class CoordinatePlotter extends StatefulWidget {
  final String url;

  const CoordinatePlotter({Key key, this.url}) : super(key: key);
  @override
  _CoordinatePlotterState createState() => _CoordinatePlotterState();
}

class _CoordinatePlotterState extends State<CoordinatePlotter> {
  double _height, _width;

  double itemLeft = 100.0, itemTop = 100.0;
  double topPadding, leftPadding;

  Map<num, List<num>> _coordinates;
  int _clickedIndex = 1000;
  Offset _startOffset;

  Map<String, dynamic> _coordinateDetails;

  num _pixels;

  @override
  void initState() {
    super.initState();
    _fetchCoordinateMock();
    // coordinates();
  }

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;
    leftPadding = MediaQuery.of(context).padding.left;
    // print(topPadding);
    // print(leftPadding);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (conetxt) => HeightAlert(
                coordinates: _coordinates,
                pixels: _pixels,
                url: widget.url,
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            if ((_width == null) || (_height == null)) {
              return Container();
            }
            num screenRatio = constraints.maxWidth / _width;
            num containerHeight = screenRatio * _width;
            num heightRatio = containerHeight / _height;
            num width = _width * heightRatio;
            num widthRatio = width / _width;
            num aWidth = (constraints.maxWidth -
                    (MediaQuery.of(context).padding.left +
                        MediaQuery.of(context).padding.right +
                        width)) /
                2;
            leftPadding = aWidth + MediaQuery.of(context).padding.left;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: width,
                        height: containerHeight,
                        color: Colors.yellow[200],
                        child: _coordinateDetails == null
                            ? Container()
                            : widget.url.isEmpty
                                ? Container()
                                : CachedNetworkImage(
                                    imageUrl: widget.url,
                                    width: constraints.maxWidth,
                                    // fit: BoxFit.fill,
                                  ),
                      ),
                    ),
                    if (_coordinates != null)
                      Container(
                        width: constraints.maxWidth,
                        height: containerHeight,
                        child: PlottedPoints(
                          onClick: (index) =>
                              setState(() => _clickedIndex = index),
                          coordinates: _coordinates,
                          leftPadding: leftPadding,
                          topPadding: topPadding,
                          screenRatio: widthRatio,
                          heightRatio: heightRatio,
                          clickedIndex: _clickedIndex,
                        ),
                      ),
                    if (_coordinates != null)
                      Container(
                          width: constraints.maxWidth,
                          height: containerHeight,
                          child: PlottedLines(
                            coordinates: _coordinates,
                            leftPadding: leftPadding,
                            screenRatio: widthRatio,
                            heightRatio: heightRatio,
                            topPadding: topPadding,
                          )),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onPanStart: (details) =>
                        _startOffset = details.globalPosition,
                    onPanUpdate: (details) => setState(() {
                      try {
                        _coordinates[_clickedIndex][0] +=
                            (details.globalPosition.dx - _startOffset.dx) / 150;
                        _coordinates[_clickedIndex][1] +=
                            (details.globalPosition.dy - _startOffset.dy) / 150;
                      } catch (e) {
                        print(e);
                      }
                    }),
                    child: Container(
                      width: constraints.maxWidth * .90,
                      height: 200,
                      color: Colors.blue[200],
                      child: Center(
                        child: Text(
                          'Select any point and Swipe here to move it',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  // void coordinates() async {
  //   Future.delayed(Duration(seconds: 1), () {
  //     setState(() => _coordinates = {
  //           1: {0: 363, 'y': 312},
  //           2: {'x': 429, 'y': 312},
  //           3: {'x': 294, 'y': 335},
  //           4: {'x': 280, 'y': 414},
  //           5: {'x': 229, 'y': 345},
  //           6: {'x': 200, 'y': 395},
  //           7: {'x': 215, 'y': 256},
  //           8: {'x': 179, 'y': 256},
  //           9: {'x': 492, 'y': 359},
  //           10: {'x': 499, 'y': 430},
  //           11: {'x': 557, 'y': 382},
  //           12: {'x': 574, 'y': 433},
  //           13: {'x': 592, 'y': 305},
  //           14: {'x': 615, 'y': 305},
  //           15: {'x': 309, 'y': 588},
  //           16: {'x': 390, 'y': 633},
  //           17: {'x': 310, 'y': 796},
  //           18: {'x': 352, 'y': 796},
  //           19: {'x': 310, 'y': 999},
  //           20: {'x': 326, 'y': 999},
  //           21: {'x': 433, 'y': 1012},
  //           22: {'x': 449, 'y': 1012},
  //           23: {'x': 415, 'y': 794},
  //           24: {'x': 465, 'y': 794},
  //           25: {'x': 390, 'y': 633},
  //           26: {'x': 458, 'y': 588},
  //           27: {'x': 280, 'y': 444},
  //           28: {'x': 499, 'y': 460},
  //           29: {'x': 297, 'y': 633},
  //           30: {'x': 488, 'y': 633}
  //         });
  //   });
  // }

  void _fetchCoordinate() {
    FirebaseFirestore.instance
        .collection('coordinates')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('url', isEqualTo: widget.url)
        .get()
        .then((value) => setState(() {
              _coordinateDetails = value.docs[0].data();
              _coordinateDetails['docid'] = value.docs[0].id;
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(_coordinateDetails['coordinates']);
              print(data);
              _coordinates = Map<num, List<num>>();
              data.forEach((key, value) {
                _coordinates[int.parse(key)] = List<num>.from(value);
              });
              // _coordinates = Map<String, List<num>>.from(
              //     _coordinateDetails['coordinates']);
              _pixels = _coordinateDetails['height_pixels'];
              _width = _coordinateDetails['width'].toDouble();
              _height = _coordinateDetails['height'].toDouble();
            }));
  }

  void _fetchCoordinateMock() {
    FirebaseFirestore.instance
        .collection('coordinates')
        .doc('FRJD7tpOENIqRx8oUodK')
        .get()
        .then((value) => setState(() {
              _coordinateDetails = value.data();
              _coordinateDetails['docid'] = value.id;
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(_coordinateDetails['coordinates']);
              print(data);
              _coordinates = Map<num, List<num>>();
              data.forEach((key, value) {
                _coordinates[int.parse(key)] = List<num>.from(value);
              });
              // _coordinates = Map<String, List<num>>.from(
              //     _coordinateDetails['coordinates']);
              _pixels = _coordinateDetails['height_pixels'];
              _width = _coordinateDetails['width'].toDouble();
              _height = _coordinateDetails['height'].toDouble();
            }));
  }
}

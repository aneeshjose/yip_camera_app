import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/plotted_lines.dart';
import 'package:point_plotter/plotted_points.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double imageHeight = 1280, imageWidth = 960;

  double itemLeft = 100.0, itemTop = 100.0;
  double topPadding, leftPadding;

  Map<num, Map<String, num>> _coordinates;
  int _clickedIndex = 1000;
  Offset _startOffset;

  @override
  void initState() {
    super.initState();
    coordinates();
  }

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;
    leftPadding = MediaQuery.of(context).padding.left;
    // print(topPadding);
    // print(leftPadding);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            num widthRatio = constraints.maxWidth / imageWidth;
            num containerHeight = widthRatio * imageHeight;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: containerHeight,
                      color: Colors.yellow[200],
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://storage.googleapis.com/finalyearproject-312006.appspot.com/aneeshjose/sample3.jpg",
                        width: constraints.maxWidth,
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
                      _coordinates[_clickedIndex]['x'] +=
                          (details.globalPosition.dx - _startOffset.dx) / 150;
                      _coordinates[_clickedIndex]['y'] +=
                          (details.globalPosition.dy - _startOffset.dy) / 150;
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

  void coordinates() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _coordinates = {
            1: {'x': 363, 'y': 312},
            2: {'x': 429, 'y': 312},
            3: {'x': 294, 'y': 335},
            4: {'x': 280, 'y': 414},
            5: {'x': 229, 'y': 345},
            6: {'x': 200, 'y': 395},
            7: {'x': 215, 'y': 256},
            8: {'x': 179, 'y': 256},
            9: {'x': 492, 'y': 359},
            10: {'x': 499, 'y': 430},
            11: {'x': 557, 'y': 382},
            12: {'x': 574, 'y': 433},
            13: {'x': 592, 'y': 305},
            14: {'x': 615, 'y': 305},
            15: {'x': 309, 'y': 588},
            16: {'x': 390, 'y': 633},
            17: {'x': 310, 'y': 796},
            18: {'x': 352, 'y': 796},
            19: {'x': 310, 'y': 999},
            20: {'x': 326, 'y': 999},
            21: {'x': 433, 'y': 1012},
            22: {'x': 449, 'y': 1012},
            23: {'x': 415, 'y': 794},
            24: {'x': 465, 'y': 794},
            25: {'x': 390, 'y': 633},
            26: {'x': 458, 'y': 588},
            27: {'x': 280, 'y': 444},
            28: {'x': 499, 'y': 460},
            29: {'x': 297, 'y': 633},
            30: {'x': 488, 'y': 633}
          });
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/plotted_ponts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double imageHeight = 1280, imageWidth = 960;

  double itemLeft = 100.0, itemTop = 100.0;
  double topPadding, leftPadding;

  Map<num, Map<String, num>> _coordinates;

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

            return ListView(
              children: [
                Column(
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
                              coordinates: _coordinates,
                              leftPadding: leftPadding,
                              topPadding: topPadding,
                              screenRatio: widthRatio,
                              onDragEnd: (index, x, y) {
                                setState(() {
                                  _coordinates[index]['x'] = x;
                                  _coordinates[index]['y'] = y;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    //   child: Container(
                    //     width: 200,
                    //     height: 200,
                    //     color: Colors.green,
                    //     child: ClipOval(clipper: ,),
                    //   ),
                    // )
                  ],
                ),
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
            3: {'x': 359, 'y': 354},
            4: {'x': 359, 'y': 452},
            5: {'x': 229, 'y': 345},
            6: {'x': 200, 'y': 395},
            7: {'x': 215, 'y': 256},
            8: {'x': 179, 'y': 256},
            9: {'x': 524, 'y': 364},
            10: {'x': 524, 'y': 462},
            11: {'x': 557, 'y': 382},
            12: {'x': 574, 'y': 433},
            13: {'x': 592, 'y': 305},
            14: {'x': 615, 'y': 305},
            15: {'x': 309, 'y': 588},
            16: {'x': 390, 'y': 633},
            17: {'x': 352, 'y': 796},
            18: {'x': 310, 'y': 796},
            19: {'x': 326, 'y': 999},
            20: {'x': 310, 'y': 999},
            21: {'x': 449, 'y': 1012},
            22: {'x': 433, 'y': 1012},
            23: {'x': 415, 'y': 794},
            24: {'x': 465, 'y': 794},
            25: {'x': 390, 'y': 633},
            26: {'x': 458, 'y': 588},
            27: {'x': 359, 'y': 384},
            28: {'x': 524, 'y': 394},
            29: {'x': 297, 'y': 633},
            30: {'x': 488, 'y': 633}
          });
    });
  }

  List<int> connections(int index) {
    Map<int, List<int>> connectionMap = {
      1: [2, 3],
      2: [1, 9],
      3: [1, 4, 5],
      4: [3, 6, 27],
      5: [3, 6, 7],
      6: [4, 5, 8],
      7: [5, 8],
      8: [6, 7],
      9: [2, 10, 11],
      10: [9, 12, 28],
      11: [9, 12, 13],
      12: [10, 11, 14],
      13: [11, 14],
      14: [12, 13],
      15: [26, 27, 29],
      16: [18, 29],
      17: [29, 18, 19],
      18: [16, 17, 20],
      19: [17, 20],
      20: [18, 19],
      21: [22, 23],
      22: [21, 24],
      23: [21, 24, 25],
      24: [22, 23, 30],
      25: [23, 30],
      26: [10, 15, 30],
      27: [4, 15, 28],
      28: [10, 27, 16],
      29: [15, 16, 17],
      30: [24, 25, 26],
    };
    return connectionMap[index];
  }
}

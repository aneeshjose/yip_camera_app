import 'package:flutter/material.dart';
import 'package:point_plotter/custom_line.dart';

class PlottedLines extends StatelessWidget {
  final Map<num, List<num>> coordinates;
  final double leftPadding, topPadding;
  final num screenRatio, heightRatio;
  static Map<int, List<int>> connectionMap = {
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
    26: [28, 15, 30],
    27: [4, 15, 28],
    28: [10, 27, 26],
    29: [15, 16, 17],
    30: [24, 25, 26],
  };

  const PlottedLines({
    Key key,
    this.leftPadding,
    this.topPadding,
    this.screenRatio,
    this.coordinates,
    this.heightRatio,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: List.generate(30, (index) {
      Offset startOffset = Offset(
          coordinates[index + 1][0] * screenRatio + leftPadding,
          coordinates[index + 1][1] * heightRatio);
      List<Offset> endOffsets = connections(index + 1)
          .map((e) => Offset(coordinates[e][0] * screenRatio + leftPadding,
              coordinates[e][1] * heightRatio))
          .toList();
      return CustomPaint(
        painter: CustomLine(
          startOffset: startOffset,
          endOffset: endOffsets,
        ),
        // child: Container(
        //   height: 5,
        //   color: Colors.green,
        // ),
      );
    }));
  }

  List<int> connections(int index) {
    return connectionMap[index];
  }
}

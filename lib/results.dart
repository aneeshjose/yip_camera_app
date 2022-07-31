import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final String uid, url;
  final Map<num, List<num>> coordinates;
  final double pixelsRatio;

  const Result({
    Key key,
    this.uid,
    this.url,
    this.coordinates,
    this.pixelsRatio,
  }) : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Map results = Map();
  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Your Measurments'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: results.keys.length,
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
            child: MeasuredItem(
              partName: results.keys.toList()[index],
              size: results[results.keys.toList()[index]],
            ),
            // child: Center(
            //   child: Row(
            //     children: [
            //       Text(results.keys.toList()[index].toString()),
            //       Text('\t:\t'),
            //       Text(
            //           results[results.keys.toList()[index]].toStringAsFixed(2)),
            //     ],
            //   ),
            // ),
          ));
        },
      ),
    );
  }

  void _fetchResults() {
    Map _coordinates = widget.coordinates;

    Map<String, num> _result = {};
    lengthMap.forEach((key, value) {
      List<num> _pixels = [];
      for (int i = 0; i < value.length; i++) {
        _pixels.add(_calculatePixels(
                _coordinates[value[i][0]][0],
                _coordinates[value[i][1]][0],
                _coordinates[value[i][0]][1],
                _coordinates[value[i][1]][1]) *
            widget.pixelsRatio);
      }
      _result[key] = (_pixels.fold(
                  0, (previousValue, element) => previousValue + element) /
              value.length) *
          (multiplicator[key] ?? 1);
    });
    setState(() {
      results = _result;
    });
  }

  Map<String, num> multiplicator = {
    'wrist': 2.4,
    'elbow': 2.4,
    'brachial': 3.14,
    'neck': 3.14,
    'chest': 2.4,
    'weist': 2.4,
    'upperthigh': 3.14,
    'knee': 3.14,
    'ankle': 3.4,
  };

  Map<String, List<List<int>>> lengthMap = {
    'wrist': [
      [13, 14],
      [8, 7],
    ],
    'forearm': [
      [14, 12],
      [7, 5],
    ],
    'elbow': [
      [11, 12],
      [5, 6],
    ],
    'arm': [
      [9, 11],
      [10, 12],
    ],
    'brachial': [
      [9, 10],
      [3, 4],
    ],
    'shoulder': [
      [2, 9],
      [3, 1],
    ],
    'neck': [
      [1, 2],
    ],
    'chest': [
      [27, 10],
    ],
    'weist': [
      [15, 26],
    ],
    'upperthigh': [
      [25, 30],
      [29, 16],
    ],
    'thigh': [
      [26, 24],
      [15, 17],
    ],
    'knee': [
      [23, 24],
      [17, 18],
    ],
    'leg': [
      [24, 22],
      [17, 19],
    ],
    'ankle': [
      [21, 22],
      [19, 20],
    ],
  };

  num _calculatePixels(num x1, num x2, num y1, num y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
}

class MeasuredItem extends StatelessWidget {
  final String partName;
  final double size;

  const MeasuredItem({Key key, this.partName, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text(
            partName,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          title: Text(
            size.toStringAsFixed(1) + ' cm',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider()
      ],
    );
  }
}

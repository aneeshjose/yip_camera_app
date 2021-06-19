import 'package:flutter/material.dart';

class PlottedPoints extends StatelessWidget {
  final Map<num, Map<String, num>> coordinates;
  final double leftPadding, topPadding;
  final Function(int, num, num) onDragEnd, onDrag;
  final num screenRatio;

  const PlottedPoints({
    Key key,
    this.coordinates,
    this.leftPadding,
    this.topPadding,
    this.onDragEnd,
    this.onDrag,
    this.screenRatio,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        30,
        (index) => Positioned(
          // left: coordinates[index + 1]['x'] * screenRatio - leftPadding - 15,
          // top: coordinates[index + 1]['y'] * screenRatio - topPadding,
          left: (coordinates[index + 1]['x'] * screenRatio) - 15.0,
          top: (coordinates[index + 1]['y'] * screenRatio) - 15.0,
          child: Draggable(
            onDragEnd: (DraggableDetails offset) {
              try {
                // print("dragEnd ${index + 1}, dx: ${offset.offset.dx - 15}, dy: ${offset.offset.dy - 15}\n" +
                //     "X: ${coordinates[index + 1]['x']}, Y: ${coordinates[index + 1]['y']}");
                onDragEnd(
                    index + 1,
                    (offset.offset.dx + 15 - screenRatio) / screenRatio -
                        leftPadding,
                    (offset.offset.dy - screenRatio + 5) / screenRatio -
                        topPadding);
              } catch (e) {}
            },
            // onDragUpdate: (offset) {
            //   print(
            //       "Local dx: ${offset.localPosition.dx}, dy: ${offset.localPosition.dy}");
            // },
            feedback: ClipOval(
              child: Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.pink, Colors.blue[700]])),
                    ),
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(),
            child: ClipOval(
              child: Container(
                color: Colors.transparent,
                width: 30,
                height: 30,
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.pink, Colors.blue[700]])),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ).toList(),
    );
  }
}

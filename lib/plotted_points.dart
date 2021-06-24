import 'package:flutter/material.dart';

class PlottedPoints extends StatelessWidget {
  final Map<num, List<num>> coordinates;
  final double leftPadding, topPadding;
  final Function(int) onClick;
  final int clickedIndex;
  final num screenRatio;
  final num heightRatio;

  const PlottedPoints({
    Key key,
    this.coordinates,
    this.leftPadding,
    this.topPadding,
    this.screenRatio,
    this.onClick,
    this.clickedIndex,
    this.heightRatio,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        30,
        (index) => index + 1 != (clickedIndex ?? 0)
            ? Positioned(
                // left: coordinates[index + 1]['x'] * screenRatio - leftPadding - 15,
                // top: coordinates[index + 1]['y'] * screenRatio - topPadding,
                left: (coordinates[index + 1][0] * screenRatio) -
                    15 +
                    leftPadding,
                top: (coordinates[index + 1][1] * heightRatio) - 15,
                child: GestureDetector(
                  onTap: () => onClick(index + 1),
                  child: ClipOval(
                    child: Container(
                      width: 30,

                      height: 30,

                      // width: 30,
                      // height: 30,
                      color: clickedIndex == null
                          ? Colors.transparent
                          : index + 1 != clickedIndex
                              ? Colors.transparent
                              : Colors.blue[200],
                      child: Center(
                        child: ClipOval(
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.pink,
                                  Colors.blue[700],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // child: Draggable(
                  //   onDragEnd: (DraggableDetails offset) {
                  //     try {
                  //       // print("dragEnd ${index + 1}, dx: ${offset.offset.dx - 15}, dy: ${offset.offset.dy - 15}\n" +
                  //       //     "X: ${coordinates[index + 1]['x']}, Y: ${coordinates[index + 1]['y']}");
                  //       onDragEnd(
                  //           index + 1,
                  //           (offset.offset.dx + 15 - screenRatio) / screenRatio -
                  //               leftPadding,
                  //           (offset.offset.dy - screenRatio + 5) / screenRatio -
                  //               topPadding);
                  //     } catch (e) {}
                  //   },
                  //   // onDragUpdate: (offset) {
                  //   //   print(
                  //   //       "Local dx: ${offset.localPosition.dx}, dy: ${offset.localPosition.dy}");
                  //   // },
                  //   feedback: ClipOval(
                  //     child: Container(
                  //       width: 30,
                  //       height: 30,
                  //       color: Colors.transparent,
                  //       child: Center(
                  //         child: ClipOval(
                  //           child: Container(
                  //             width: 7,
                  //             height: 7,
                  //             decoration: BoxDecoration(
                  //               gradient: LinearGradient(
                  //                 begin: Alignment.topLeft,
                  //                 end: Alignment.bottomRight,
                  //                 colors: [
                  //                   Colors.pink,
                  //                   Colors.blue[700],
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   childWhenDragging: Container(),
                  //   child: ClipOval(
                  //     child: Container(
                  //       color: clickedIndex == null
                  //           ? Colors.transparent
                  //           : index + 1 != clickedIndex
                  //               ? Colors.transparent
                  //               : Colors.blue[200],
                  //       width: 30,
                  //       height: 30,
                  //       child: Center(
                  //         child: ClipOval(
                  //           child: Container(
                  //             width: 7,
                  //             height: 7,
                  //             decoration: BoxDecoration(
                  //                 gradient: LinearGradient(
                  //                     begin: Alignment.topLeft,
                  //                     end: Alignment.bottomRight,
                  //                     colors: [Colors.pink, Colors.blue[700]])),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              )
            : Positioned(
                // left: coordinates[index + 1]['x'] * screenRatio - leftPadding - 15,
                // top: coordinates[index + 1]['y'] * screenRatio - topPadding,
                left: (coordinates[index + 1][0] * screenRatio) -
                    3 / 2 +
                    leftPadding,
                top: (coordinates[index + 1][1] * screenRatio) -
                    3 / 2 +
                    topPadding,
                child: GestureDetector(
                  onTap: () => onClick(index + 1),
                  child: ClipOval(
                    child: ClipOval(
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.pink,
                              Colors.blue[700],
                            ],
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

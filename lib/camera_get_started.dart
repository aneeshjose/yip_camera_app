import 'package:flutter/material.dart';
import 'package:point_plotter/camera.dart';

class CameraGetStarted extends StatefulWidget {
  const CameraGetStarted({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<CameraGetStarted> createState() => _CameraGetStartedState();
}

class _CameraGetStartedState extends State<CameraGetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('images/sizeme.png')),

                const SizedBox(height: 50),

                const Text('Place Your Body Within the Margin',
                    style: TextStyle(fontSize: 20)),
                const Text('to Get Sized', style: TextStyle(fontSize: 20)),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.black87,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraPage())),
          elevation: 0,
          label: const Text(
            "Get Started",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

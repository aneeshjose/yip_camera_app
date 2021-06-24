import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_plotter/results.dart';

class HeightAlert extends StatefulWidget {
  final String url;
  final Map<num, List<num>> coordinates;
  final num pixels;

  const HeightAlert({Key key, this.url, this.coordinates, this.pixels})
      : super(key: key);
  _HeightAlertState createState() => _HeightAlertState();
}

class _HeightAlertState extends State<HeightAlert> {
  int height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (text) {
                height = int.tryParse(text);
                print(height);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, //this has no effect
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Enter Your Real Height",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => {
                if (height != null)
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Result(
                          url: widget.url,
                          uid: FirebaseAuth.instance.currentUser.uid,
                          coordinates: widget.coordinates,
                          pixelsRatio: height / widget.pixels,
                        ),
                      ))
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter the height'),
                      ),
                    )
                  }
              },
              child: Text('Finish'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black87)),
            )
          ],
        ),
      ),
    );
  }
}

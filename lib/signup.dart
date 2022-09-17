import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:point_plotter/homepage.dart';
import 'package:point_plotter/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String _email, _password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register to SizeME'),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'images/sizeme.png',
                    scale: 2,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    focusColor: Colors.lightGreen,
                    hoverColor: Colors.lightGreen,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    labelStyle: new TextStyle(color: Colors.black54),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "This Field Is Required"),
                    EmailValidator(errorText: "Invalid Email Address"),
                  ]),
                  onChanged: (val) {
                    _email = val;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      labelStyle: new TextStyle(color: Colors.black54),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password Is Required"),
                      MinLengthValidator(6,
                          errorText: "Minimum 6 Characters Required"),
                    ]),
                    onChanged: (val) {
                      _password = val;
                    },
                  ),
                ),
                ElevatedButton(
                  // passing an additional context parameter to show dialog boxs
                  onPressed: () async {
                    // try{
                    //   login();
                    //  // error = true;
                    // }catch(e){
                    //   error=true;
                    // }
                    try {
                      UserCredential creds =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email.trim(), password: _password);
                      _showMessage('Signed up successfully');
                      if (creds.user != null)
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                    } catch (e) {
                      _showMessage(e);
                    }
                  },
                  // color: Colors.black87,
                  // textColor: Colors.white,
                  child: Text(
                    "Sign Up",
                  ),
                ),

                TextButton(
                  // passing an additional context parameter to show dialog boxs
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  // textColor: Colors.blueGrey,
                  child: Text(
                    "Sign In Here",
                  ),
                ),

                //error?Text('Wrong Email or Password',style: TextStyle(color:Colors.red),):Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

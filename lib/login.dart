import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:point_plotter/homepage.dart';
import 'package:point_plotter/main.dart';
import 'package:point_plotter/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
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
                RaisedButton(
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
                          await _auth.signInWithEmailAndPassword(
                              email: _email, password: _password);
                      _showMessage('Logged up successfully');
                      if (creds.user != null)
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                    } catch (e) {
                      _showMessage(e.toString());
                    }
                  },
                  color: Colors.black87,
                  textColor: Colors.white,
                  child: Text(
                    "Login",
                  ),
                ),

                FlatButton(
                  // passing an additional context parameter to show dialog boxs
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
                  },
                  textColor: Colors.blueGrey,
                  child: Text(
                    "Sign Up Here",
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

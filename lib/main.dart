import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
String email="",pass="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: t1,),
          TextField(controller: t2,),
          RaisedButton(onPressed: () async {
            email=t1.text;
            pass=t2.text;
            try {
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: pass
              );

              bool verify=userCredential.user.emailVerified;
              if(verify==false)
                {
                  await userCredential.user.sendEmailVerification();
                }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
              } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
              }
            } catch (e) {
              print(e);
            }
          },child: Text("register"),),

          RaisedButton(onPressed: () async {
            email=t1.text;
            pass=t2.text;

            try {
              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: pass
              );
              if(userCredential.user.emailVerified==false)
                {
                  print("please verify cod");
                }
              else
                {
                  print("rong password");
                }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          },child: Text("login"),)
        ],
      )
    );
  }
}

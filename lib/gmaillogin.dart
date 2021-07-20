import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: gmail()));
}

class gmail extends StatefulWidget {
  @override
  _gmailState createState() => _gmailState();
}

class _gmailState extends State<gmail> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    User user=auth.currentUser;
    print(user);

    if(user!=null)
    {

      WidgetsBinding.instance.addPostFrameCallback((_) {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return nextpeg(user);
        },));

      });


    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RaisedButton(onPressed: () {
        signInWithGoogle().then((value) {
          User user=auth.currentUser;
          if(value.user.email!=null)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return nextpeg(user);
              },));
            }
          // User != null?user.auth.currentUser;
        });
      },child: Text("google signin"),),
    );
  }
}


class nextpeg extends StatefulWidget {
  User user;
  nextpeg(this.user);

  @override
  _nextpegState createState() => _nextpegState();
}

class _nextpegState extends State<nextpeg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
      body: ListTile(
        title: Text(widget.user.email),
        subtitle: Text(widget.user.displayName),
        leading: Image.network(widget.user.photoURL),
        trailing: IconButton(onPressed: () async {
          await GoogleSignIn().signOut();
          await  FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return gmail();
          },));
        },icon: Icon(Icons.logout),),

      ),
    );
  }
}

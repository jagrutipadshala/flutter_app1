import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: phone(),debugShowCheckedModeBanner: false,));
}
class phone extends StatefulWidget {
  @override
  _phoneState createState() => _phoneState();
}

class _phoneState extends State<phone> {
TextEditingController phoneno_c=TextEditingController();
TextEditingController otp_c=TextEditingController();


  String phoneno="";
  String otp="";
  String veri_id="";
FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: phoneno_c,),
          TextField(controller: otp_c,),
          RaisedButton(onPressed: () async {

          phoneno=phoneno_c.text;

              print(phoneno);

          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+91$phoneno',
            verificationCompleted: (PhoneAuthCredential credential) async {

              setState(() {
                otp_c.text=credential.smsCode;
              });

              await auth.signInWithCredential(credential);
              print("auto verify");
            },

            verificationFailed: (FirebaseAuthException e) {
              print("failed");
            },


            codeSent: (verificationId,forceResendingToken){
              print("cod sent");

              setState(() {
                veri_id=verificationId;
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
          },child: Text("send otp"),),
          RaisedButton(onPressed: () async {
           otp= otp_c.text;

            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: veri_id, smsCode: otp);
            await auth.signInWithCredential(credential);
            print("manual verify");

          },child: Text("verify otp"),)
        ],
      ),
    );
  }
}

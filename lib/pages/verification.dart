import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerficationEmail extends StatefulWidget {
  const VerficationEmail({Key? key}) : super(key: key);

  @override
  State<VerficationEmail> createState() => _VerficationEmailState();
}

class _VerficationEmailState extends State<VerficationEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [TextButton(onPressed: (){
          FirebaseAuth.instance.signOut();
        }, child: Text("Logout"))],
      ),
      body: Center(
        child: Text("verify your email"),
      ),
    );
  }
}

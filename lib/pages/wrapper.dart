import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:predev/pages/verification.dart';

import 'home.dart';
import 'login.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    user?.reload();
    if (user != null) {
      if (user.emailVerified) {
        return Home();
      } else {
        return VerficationEmail();
      }
    } else{
      return Login();
    }
  }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:predev/pages/wrapper.dart';

enum AuthStatus {
  notAuthed,
  authed,
  loading,
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  AuthStatus _authstaus = AuthStatus.notAuthed;

  File? imgPath;

  bool obsecure = true;

  String error = "";

  pickimg() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      imgPath = File(pickedFile!.path);
    });
  }

  Future<User?> createuser(String email, String password) async {
    try {
      setState(() {
        _authstaus = AuthStatus.loading;
      });

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);


      if (userCredential.user != null) {

        setState(() {
          _authstaus = AuthStatus.authed;
        });

      }

      await userCredential.user!.sendEmailVerification();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          error = 'The account already exists for that email.';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 100, 20, 100),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 450,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickimg();
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              image: imgPath == null
                                  ? null
                                  : DecorationImage(
                                  image: FileImage(imgPath!),
                                  fit: BoxFit.fill),
                              color: Colors.grey[300],
                              shape: BoxShape.circle),
                          child: imgPath == null
                              ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "this field is necessary";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "this field is necessary";
                          }
                          if (!val.contains('@')) {
                            return "enter a valid email";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obsecure,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "enter the password";
                          }
                          if (val.length < 3 || val.length > 12) {
                            return "password must be between 3 to 12 chars";
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye),
                            ),
                            hintText: 'password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (imgPath != null) {
                            final user = createuser(emailController.text,
                                passwordController.text)
                                .then((value) {
                              if (value != null && _authstaus == AuthStatus.authed) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Wrapper()));
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "image must be selected");
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(40)),
                          child: _authstaus == AuthStatus.loading
                              ? Text(
                            'Loading...',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                              : Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${error}",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

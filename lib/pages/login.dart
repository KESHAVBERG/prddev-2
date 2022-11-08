import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:predev/pages/register.dart';
import 'package:predev/pages/wrapper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthStatus _authstaus = AuthStatus.notAuthed;
  bool obsecure = true;

  String error = "";

  Future<User?> signInuser(String email, String password) async {
    try {
      setState(() {
        _authstaus = AuthStatus.loading;
      });
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        setState(() {
          _authstaus = AuthStatus.authed;
        });
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        setState(() {
          error = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          error = 'Wrong password provided for that user.';
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 200, 20, 200),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [

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
                        obscureText:obsecure ,
                        controller: passwordController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "enter the password";
                          }
                          if (val.length < 3 || val.length > 12) {
                            return "password must be between 3 to 12 chars";
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                          },
                          child: Text('Sign up'),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          final user = signInuser(
                              emailController.text, passwordController.text).then((value){
                            if(value != null && _authstaus == AuthStatus.authed){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Wrapper()));
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(40)),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Text("${error}", style: TextStyle(color: Colors.red),)
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

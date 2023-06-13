import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String _username = '', _email = '', _password = '';
  bool _rememberMe = false;
  final storage = FlutterSecureStorage();


  @override
  void initState(){
    super.initState();
    _loadCredentials();
  }

  _loadCredentials() async {
    final username = await storage.read(key: 'username');
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    setState(() {
      _username = username ?? '';
      _email = email ?? '';
      _password = password ?? '';
    });
    print('Stored credentials:');
    print('Username: $_username');
    print('Email: $_email');
    print('Password: $_password');
  }
      // デバッグ用の出力




  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child:AutofillGroup(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: _username,
                  autofillHints:const[AutofillHints.username],
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _email,
                  autofillHints:const[AutofillHints.email],
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _password,
                  autofillHints:const[AutofillHints.password],
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
            
            
                    SizedBox(height: 20),
                                    CheckboxListTile(
                      title: Text("ログイン情報を保存する"),
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                          // Signed in       
                          CollectionReference users = FirebaseFirestore.instance.collection('users');
                          users.doc(userCredential.user!.uid).set({
                            'username': _username,
                            'email': _email,
                          });

                          // Store the credentials
                          await storage.write(key: 'username', value: _username);
                          await storage.write(key: 'email', value: _email);
                          await storage.write(key: 'password', value: _password);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Signed in!')),
                          );
                        } on FirebaseAuthException catch (e) {
                          // Handle error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    child: Text('Sign In'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        );
                        // User registered
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registered!')),
                        );
                      } on FirebaseAuthException catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

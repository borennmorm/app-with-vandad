// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_vandad/firebase_options.dart';
import 'package:flutter_application_vandad/views/register.dart';

import 'home.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.grey[200],
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Enter your password",
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);

                            // Handle successful login here
                            print(
                                'Successfully logged in: ${userCredential.user}');

                            if (!mounted)
                              return; // Ensure the widget is still mounted
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home/',
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('User not found');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User not found')),
                              );
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Wrong password')),
                              );
                            } else {
                              print('Something else happened');
                              print(e.code);
                              print(e.message);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.message}')),
                              );
                            }
                          } catch (e) {
                            print('An unknown error occurred');
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('An unknown error occurred')),
                            );
                          }
                        },
                        child: const Text("Login")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/register/',
                                (route) => false,
                              );
                            },
                            child: const Text("Resgiter"))
                      ],
                    )
                  ],
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

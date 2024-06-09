import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_vandad/firebase_options.dart';
import 'package:flutter_application_vandad/views/note_view.dart';
import 'package:flutter_application_vandad/views/verify_email_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<FirebaseApp>? _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && user.emailVerified) {
              return const NoteView();
            } else {
              return const Center(child: VerifyEmailView());
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

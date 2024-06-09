import 'package:flutter/material.dart';
import 'package:flutter_application_vandad/views/home.dart';

import 'views/login.dart';
import 'views/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomePage(),
      },
    );
  }
}

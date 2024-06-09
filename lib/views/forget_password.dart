import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Entry point for the ForgetPasswordView widget
class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

// State for the ForgetPasswordView widget
class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  // FirebaseAuth instance to handle authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TextEditingController to control the email input field
  late TextEditingController _emailController;

  // Initializes the state
  @override
  void initState() {
    super.initState();
    _emailController =
        TextEditingController(); // Initializes the email controller
  }

  // Disposes of the controller when the widget is destroyed
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Function to reset the password
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      // Check if the email exists in the authentication system
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        // Show an error if no user is found for that email
        showErrorSnackbar(context, 'No user found for that email.');
        return;
      }

      // Send the password reset email
      await _auth.sendPasswordResetEmail(email: email);
      // Show a snackbar confirming that the email was sent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sent, Please check your email'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      // Show an error snackbar with the appropriate message
      showErrorSnackbar(context, errorMessage);
    } catch (e) {
      // Handle any other errors
      showErrorSnackbar(context, 'An error occurred. Please try again.');
    }
  }

  // Function to show an error snackbar with a message
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackbar(
    BuildContext context,
    String text,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter your email address ',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // TextField for the user to enter their email address
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            // Button to trigger the password reset
            SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    final email = _emailController.text
                        .trim(); // Get and trim the email input
                    if (email.isNotEmpty) {
                      resetPassword(
                          context, email); // Attempt to reset the password
                    } else {
                      showErrorSnackbar(context,
                          'Please enter an email address.'); // Show error if email is empty
                    }
                  },
                  child: const Text("Reset Password"),
                )),
          ],
        ),
      ),
    );
  }
}

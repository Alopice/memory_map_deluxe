import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memory_map/pages/google_login_page.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.logout_rounded, size: 30,),
      onTap: () async {
  try {
    GoogleSignIn accountAction = GoogleSignIn();
    await accountAction.signOut();
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase as well
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GoogleLoginPage()),
      (route) => false, // Removes all routes
    );
  } catch (error) {
    print("Logout error: $error");
  }
}
    );
  }
}
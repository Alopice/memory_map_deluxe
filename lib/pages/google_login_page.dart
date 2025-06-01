import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_map/pages/home_page.dart';
import 'package:memory_map/utils/page_viewer.dart';

class GoogleLoginPage extends StatefulWidget {
const GoogleLoginPage({super.key});
  @override
  _GoogleLoginPageState createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print("Google sign-in error: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        
        children: [
          Image.asset(
          'assets\\background_assets\\background_login.jpeg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlowText(
                "AR",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily:  'PlaywriteIN',
                ),
              ),
              GlowText(
                "Memory Map",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily:  'PlaywriteIN',
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            
                CustomPaint(
              
                    size: Size(double.infinity, 300), // Adjust height as needed
                    painter: CurvedBackgroundPainter(),
                    
                  ),
                  
              ]
              
            
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
              child: Text(
                "Discover, share, and relive memories in AR—adventure awaits!", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold ),
                  textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: GlowButton(
                width: 300,
                  color: Colors.blue,
                  child: Text("Get started", style: TextStyle(color: Colors.black, fontSize: 20),),
                  onPressed: () async {
                    User? user = await _signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageViewer())
                      );
                    }
                  },
                ),
            ),
          ],),
        )
            
        ] 
      ),
    );
  }
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.indigo;

    Path path = Path();
    path.moveTo(0, 0); 
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.75, -size.height * 0.2, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}







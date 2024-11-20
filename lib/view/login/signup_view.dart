import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:finalproject/common/colo_extension.dart';
import 'package:finalproject/common_widget/round_button.dart';
import 'package:finalproject/common_widget/round_textfield.dart';
import 'package:finalproject/view/login/complete_profile_view.dart';
import 'package:finalproject/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // Controllers for the input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isCheck = false;
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to free resources
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle user registration
  Future<void> _registerUser() async {
    if (!isCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Privacy Policy and Terms.')),
      );
      return;
    }

    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Display success message and navigate to the Complete Profile page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the Complete Profile page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CompleteProfileView()),
      );

      // Optionally, you can show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Login Successful')),
      );
    }
  } catch (e) {
    // Handle any errors that occur during sign-in
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google Login Failed: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                RoundTextField(
                  controller: _firstNameController,
                  hitText: "First Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _lastNameController,
                  hitText: "Last Name",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                    onPressed: () {}, // Handle password visibility toggle
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        "assets/img/show_password.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: TColor.gray,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerms of Use",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.4),
                isLoading
                    ? const CircularProgressIndicator()
                    : RoundButton(
                        title: "Register",
                        onPressed: _registerUser,
                      ),
                SizedBox(height: media.width * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: signInWithGoogle, // Handle Google login
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: media.width * 0.04),
                    GestureDetector(
                      onTap: () {}, // Handle Facebook login
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

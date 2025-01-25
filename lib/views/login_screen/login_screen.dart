import 'package:ai_story_gen/firebase/auth/firebase_email_password.dart';
import 'package:ai_story_gen/firebase/google_sign_in/google_signin.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/botom_nav_bar/bottom_nav_bar.dart';
import 'package:ai_story_gen/views/register_screen/register_screen.dart';
import 'package:ai_story_gen/widgets/custom_text_filed.dart';
import 'package:ai_story_gen/widgets/sign_in_methods.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              right: size.width * .03,
              left: size.width * .03,
              bottom: size.height * .02,
              top: size.height * .001,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: size.height * .03,
              children: [
                //logo
                Center(
                    child: Image.asset(
                  "assets/icon/icon.png",
                  scale: 3,
                )),
                //title
                Text(
                  "Welcome to AI Story Gen",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  spacing: size.height * .02,
                  children: [
                    CustomTextFiled(
                      passwordController: emailController,
                      icon: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      hintText: "Enter Email",
                      labelText: "Email",
                      obscureText: false,
                    ),
                    CustomTextFiled(
                      passwordController: passwordController,
                      icon: Icon(
                        Icons.password_outlined,
                        color: Colors.black,
                      ),
                      hintText: 'Enter password',
                      labelText: "Password",
                      obscureText: true,
                    ),
                    SizedBox(height: size.height * .01),
                    GestureDetector(
                      onTap: () {
                        if (passwordController.text == "" || emailController.text == "") {
                          Dialogs.showSnackBarError(
                            context,
                            "Please fill mail and password",
                          );
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
                          Dialogs.showSnackBarError(
                            context,
                            "Invalid email format",
                          );
                        } else {
                          FirebaseEmailPassword().signInWithPassword(
                            context,
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                      child: Container(
                        height: 45,
                        width: size.width * .9,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * .08),
                    Text(
                      "or continue with",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await GoogleSignin.signInWithGoogle(context).then((onValue) {
                          if (context.mounted) {
                            Dialogs.showSnackBar(context, "Login Successful");

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        });
                      },
                      child: SignInMethods(
                        text: 'Google',
                        icon: 'assets/google.png',
                        widthsize: size.width * .9,
                      ),
                    ),
                    SignInMethods(
                      text: 'Facebook',
                      icon: 'assets/facebook.png',
                      widthsize: size.width * .9,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Create now",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

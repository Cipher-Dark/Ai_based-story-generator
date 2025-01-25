import 'package:ai_story_gen/firebase/auth/firebase_register_email_password.dart';
import 'package:ai_story_gen/firebase/google_sign_in/google_signin.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/login_screen/login_screen.dart';
import 'package:ai_story_gen/widgets/custom_text_filed.dart';
import 'package:ai_story_gen/widgets/sign_in_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new_outlined),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: size.height * .02),
                  Center(child: Image.asset("assets/icon/icon.png", scale: 3)),
                  SizedBox(width: 30),
                  Text(
                    "Register to AI Story Gen",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * .04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 10,
                      children: [
                        CustomTextFiled(
                          passwordController: nameController,
                          icon: Icon(
                            CupertinoIcons.person_circle,
                            color: Colors.black,
                          ),
                          hintText: "Enter your name",
                          labelText: "Name",
                          obscureText: false,
                        ),
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
                          obscureText: false,
                        ),
                        CustomTextFiled(
                          passwordController: repeatPasswordController,
                          icon: Icon(
                            Icons.password_outlined,
                            color: Colors.black,
                          ),
                          hintText: 'Enter repeat password',
                          labelText: "Repeat Password",
                          obscureText: true,
                        ),
                        SizedBox(height: size.height * .02),
                        GestureDetector(
                          onTap: () {
                            if (passwordController.text == "" || emailController.text == "" || repeatPasswordController.text == "" || nameController.text == "") {
                              Dialogs.showSnackBarError(context, "fill All details");
                            } else if (passwordController.text != repeatPasswordController.text) {
                              Dialogs.showSnackBarError(context, "Password does't match");
                            } else {
                              FirebaseRegisterEmailPassword().registrationWithEmailPass(
                                context: context,
                                emailEditingController: emailController.text,
                                passEditingController: passwordController.text,
                                nameEditingController: nameController.text,
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
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Already have account? ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            children: [
                              WidgetSpan(
                                  child: InkWell(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                  (route) => false,
                                ),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * .03),
                        Text(
                          "or continue with",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            GoogleSignin.signInWithGoogle(context);
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
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

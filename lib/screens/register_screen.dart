import 'package:ai_story_gen/firebase/auth/firebase_register_email_password.dart';
import 'package:ai_story_gen/screens/login_screen.dart';
import 'package:ai_story_gen/widgets/custom_text_Filed.dart';
import 'package:ai_story_gen/widgets/sign_in_methods.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(child: Image.asset("assets/logo.png")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 30),
                  Text(
                    "Register to AI Story Gen",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 10,
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
                          GestureDetector(
                            onTap: () {
                              if (passwordController.text == "" || emailController.text == "" || repeatPasswordController.text == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black54,
                                    content: Center(
                                      child: Text(
                                        "Please fill mail and password",
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (passwordController.text != repeatPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black54,
                                    content: Center(
                                      child: Text(
                                        "Password does't match",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                FirebaseRegisterEmailPassword().registrationWithEmailPass(
                                  context,
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: Container(
                              height: 40,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have account? ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "or continue with",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Column(
                            spacing: 30,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SignInMethods(
                                text: 'Google',
                                icon: 'assets/google.png',
                                Widthsize: size.width * .9,
                              ),
                              SignInMethods(
                                text: 'Google',
                                icon: 'assets/facebook.png',
                                Widthsize: size.width * .9,
                              ),
                            ],
                          ),
                        ],
                      ),
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

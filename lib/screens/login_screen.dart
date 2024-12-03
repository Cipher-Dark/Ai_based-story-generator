import 'package:ai_story_gen/screens/register_screen.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isDarkMode = false;

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEditingController.text,
          password: passwordEditingController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Login Successfull",
            style: TextStyle(fontSize: 20),
          )));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoryInputPage(
            toggleTheme: () {
              setState(
                () {
                  isDarkMode = !isDarkMode;
                },
              );
            },
            isDarkMode: isDarkMode,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Invalid User",
              style: TextStyle(fontSize: 20),
            )));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Invalid crediantial",
              style: TextStyle(fontSize: 20),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Email";
                      }
                      return null;
                    },
                    controller: userEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                    controller: passwordEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter password',
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.password_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      if (passwordEditingController.text == "" ||
                          userEditingController.text == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.orangeAccent,
                                content: Text(
                                  "Please fill mail and password",
                                  style: TextStyle(fontSize: 20),
                                )));
                      }
                      userLogin();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 13.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?"),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

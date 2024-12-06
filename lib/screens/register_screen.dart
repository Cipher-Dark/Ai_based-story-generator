import 'package:ai_story_gen/screens/login_screen.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Declare controllers
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  TextEditingController passRepeatEditController = TextEditingController();

  // Declare the form key outside of build method
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Registration function
  registeration() async {
    if (passRepeatEditController.text != "" && nameEditingController.text != "" && emailEditingController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailEditingController.text,
          password: passRepeatEditController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registration Successful",
          style: TextStyle(fontSize: 20),
        )));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StoryInputPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password is too weak",
                style: TextStyle(fontSize: 20),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Email already in use",
                style: TextStyle(fontSize: 20),
              )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "An error occurred, please try again",
                style: TextStyle(fontSize: 20),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Register"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                controller: nameEditingController,
                decoration: const InputDecoration(
                  hintText: "Enter full name",
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
                controller: emailEditingController,
                decoration: const InputDecoration(
                  hintText: "Enter email",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                controller: passEditingController,
                decoration: const InputDecoration(
                  hintText: "Enter password",
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != passEditingController.text) {
                    return "Passwords don't match!";
                  }
                  return null;
                },
                controller: passRepeatEditController,
                decoration: const InputDecoration(
                    hintText: "Enter password again ",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.green,
                    ),
                    labelText: "Confirm Password"),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      if (nameEditingController.text == "" || emailEditingController.text == "" || passEditingController.text == "" || passRepeatEditController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text(
                              "Please fill all fields",
                              style: TextStyle(fontSize: 20),
                            )));
                      } else if (passEditingController.text != passRepeatEditController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text(
                              "Password does't match",
                              style: TextStyle(fontSize: 20),
                            )));
                      } else {
                        registeration();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                      decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account!"),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
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

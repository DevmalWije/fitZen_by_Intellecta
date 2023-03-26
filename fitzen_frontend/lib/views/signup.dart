import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/customized_textField.dart';
import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameContoller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Image.asset(
                    "assets/login.jpg",
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Text(
                          "Hello!\nRegister to get start.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Nexa",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomizedTextField(
                        myController: _usernameContoller,
                        hintText: "Enter Username",
                        isPassword: false,
                      ),
                      CustomizedTextField(
                        myController: _emailController,
                        hintText: "Enter Email",
                        isPassword: false,
                      ),
                      CustomizedTextField(
                        myController: _passwordController,
                        hintText: "Enter Password",
                        isPassword: true,
                      ),
                      CustomizedTextField(
                        myController: _confirmPasswordController,
                        hintText: "Confirm Password",
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      //button
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          backgroundColor: kBlue,
                          text: "Signup",
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                          onPressed: () {},
                        ),
                      ),

                      //sign up
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Color(0XFF6A707C),
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

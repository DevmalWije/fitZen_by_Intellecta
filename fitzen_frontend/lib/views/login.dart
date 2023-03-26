import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/views/signup.dart';
import 'package:fitzen_frontend/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/customized_textField.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      child: Text(
                        "Welcome back!\nGlad to see you, Again!",
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
                      myController: _emailController,
                      hintText: "Enter your Email",
                      isPassword: false,
                    ),
                    CustomizedTextField(
                      myController: _passwordController,
                      hintText: "Enter your Password",
                      isPassword: true,
                    ),

                    SizedBox(height: 30),
                    //button
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        backgroundColor: kBlue,
                        text: "Login",
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        onPressed: () {},
                      ),
                    ),

                    //sign up
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color(0XFF6A707C),
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
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
    );
  }
}

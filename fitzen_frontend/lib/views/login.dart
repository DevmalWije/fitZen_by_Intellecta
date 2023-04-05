import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/user_controller.dart';
import 'package:fitzen_frontend/views/signup.dart';
import 'package:fitzen_frontend/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/customized_text_field.dart';
import 'package:provider/provider.dart';
import 'package:fitzen_frontend/views/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

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
                        isLoading: isLoading,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        onPressed: () async {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          if (email.isEmpty || password.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all the fields!"),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            bool isSuccess =
                                await Provider.of<UserController>(context, listen: false)
                                    .signIn(email, password, onError: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ));
                            });
                            setState(() {
                              isLoading = false;
                            });
                            if (isSuccess) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(builder: (context) => Home()),
                                  (Route<dynamic> route) => false);
                            }
                          }
                        },
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

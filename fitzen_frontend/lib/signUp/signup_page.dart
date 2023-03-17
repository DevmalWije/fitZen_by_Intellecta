import 'package:fitzen_frontend/login/login_screen.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/widgets/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/customized_textField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/logo.png"))),
                    ),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Hello! Register to get \nStart.",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nexa")),
                ),

                CustomizedTextfield(
                  myController: _usernameContoller,
                  hintText: "Enter Username",
                  isPassword: false,
                ),
                CustomizedTextfield(
                  myController: _emailController,
                  hintText: "Enter Email",
                  isPassword: false,
                ),
                CustomizedTextfield(
                  myController: _passwordController,
                  hintText: "Enter Password",
                  isPassword: true,
                ),
                CustomizedTextfield(
                  myController: _confirmPasswordController,
                  hintText: "Confirm Password",
                  isPassword: true,
                ),

                CustomizedButton(
                  buttonText: "Sign Up",
                  buttonColor: Color.fromARGB(255, 72, 133, 231),
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.height * 0.15,
                        color: Colors.grey,
                      ),
                      const Text("Or Login with",
                          style: TextStyle(color: Color(0XFF6A707C))),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.height * 0.15,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                // Center(
                //   child: Column(
                //     children: [
                //       SignInButton(
                //         Buttons.Google,
                //         text: "Sign up with Google",
                //         onPressed: () {},
                //       ),
                //       SizedBox(height: 2),
                //       SignInButton(
                //         Buttons.Facebook,
                //         text: "Sign up with Facebook",
                //         onPressed: () {},
                //       ),
                //     ],
                //   ),
                // ),
                /*SizedBox(
              height: 100,
            ),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 8, 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Color(0XFF6A707C),
                            //fontSize: 15
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          child: Text(
                            "Login.",
                            style: TextStyle(
                              color: Colors.orange,
                              //fontSize: 15
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

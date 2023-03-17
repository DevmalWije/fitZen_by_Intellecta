import 'package:fitzen_frontend/signUp/signup_page.dart';
import 'package:fitzen_frontend/views/home.dart';
import 'package:fitzen_frontend/widgets/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/customized_textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/background.jpg"))),
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
                child: Text("Welcome back! Glad \nto see you, Again!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Nexa")),
              ),
              CustomizedTextfield(
                myController: _emailController,
                hintText: "Enter your Email",
                isPassword: false,
              ),
              CustomizedTextfield(
                myController: _passwordController,
                hintText: "Enter your Password",
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0XFF6A707C),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              CustomizedButton(
                buttonText: "Login",
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
              //         text: "Login with Google",
              //         onPressed: () {},
              //       ),
              //       SizedBox(height: 10,),
              //       SignInButton(
              //         Buttons.Facebook,
              //         text: "Login with Facebook",
              //         onPressed: () {},
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 8, 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Text(
                        "Don't have an account?",
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
                                  builder: (_) => const SignUpScreen()));
                        },
                        child: Text(
                          "Sign Up.",
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
    );
  }
}

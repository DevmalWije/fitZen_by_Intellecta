import 'package:flutter/material.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('FitZen Sign up'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter your name'),
              ),
              TextField(
                decoration:
                InputDecoration(hintText: 'Enter your email address'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter your password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

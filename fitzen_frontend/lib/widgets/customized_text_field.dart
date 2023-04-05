import 'package:flutter/material.dart';

class CustomizedTextField extends StatefulWidget {
  final TextEditingController myController;
  final String? hintText;
  final bool isPassword;

  const CustomizedTextField(
      {super.key, required this.myController, this.hintText, this.isPassword = false});

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
  bool passwordVisible = false;

  @override
  void initState() {
    passwordVisible = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        obscureText: passwordVisible,
        controller: widget.myController,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    child: Icon(!passwordVisible ? Icons.visibility : Icons.visibility_off)),
              )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: const Color(0xffe8ecf4),
          filled: true,
          labelText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

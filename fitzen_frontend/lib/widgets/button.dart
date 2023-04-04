import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final Function() onPressed;

  const Button(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      this.icon,
      required this.onPressed,
      this.padding,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: !isLoading ? backgroundColor : Colors.grey,
        padding: padding ?? EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: !isLoading
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 25,
                  ),
                if (icon != null) SizedBox(width: 20),
                Text(
                  text,
                  style: Theme.of(context).textTheme.button,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
    );
  }
}

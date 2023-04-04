import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final double? titleSize;
  final double? valueSize;
  final double? borderRadius;

  const SummaryCard({Key? key, required this.title, required this.value, required this.color, this.padding, this.titleSize, this.valueSize, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 36, horizontal: 42),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                color: Colors.white,
                fontSize: valueSize
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: titleSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

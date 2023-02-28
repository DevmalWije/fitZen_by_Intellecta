import 'package:flutter/material.dart';
import 'package:fitzen_frontend/constants.dart';

class SettingCard extends StatelessWidget {
  final String settingName;
  final String value;
  const SettingCard({Key? key, required this.settingName, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settingName,
              style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

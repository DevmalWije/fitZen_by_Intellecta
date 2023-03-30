import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:fitzen_frontend/widgets/button.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          children: [
            //app bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackButton(),
                SizedBox(width: 20),
                Icon(
                  Icons.settings,
                  color: kBlue,
                  size: 40,
                ),
                SizedBox(width: 20),
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
            SizedBox(height: 70),

            //setting tile
            Row(
              children: [
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                ),
                SizedBox(width: 100),
                Expanded(
                  child: SettingCard(
                    settingName: "Camera",
                    value: "HD Webcam",
                  ),
                )
              ],
            ),
            Expanded(child: SizedBox.shrink()),

            //save button
            Button(
              backgroundColor: kPurple,
              text: "Save",
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

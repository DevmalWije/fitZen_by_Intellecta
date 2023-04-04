import 'package:fitzen_frontend/constants.dart';
import 'package:fitzen_frontend/controllers/settings_controller.dart';
import 'package:fitzen_frontend/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Provider.of<SettingsController>(context);
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
                    settingName: "Poor Posture Notification Interval",
                    values: [1, 5, 10, 30, OFF],
                    defaultValue: settingsController.poorPostureNotificationInterval,
                    onChanged: (value) =>
                        settingsController.poorPostureNotificationInterval = value,
                  ),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: SettingCard(
                    settingName: "Low Blink Count Notification",
                    values: [ON, OFF],
                    defaultValue: settingsController.lowBlinkCountNotification,
                    onChanged: (value) => settingsController.lowBlinkCountNotification = value,
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: SettingCard(
                    settingName: "20-20-20 Rule Notification",
                    values: [ON, OFF],
                    defaultValue: settingsController.twentyTwentyTwentyNotification,
                    onChanged: (value) => settingsController.twentyTwentyTwentyNotification = value,
                  ),
                ),
                SizedBox(width: 80),
                Expanded(child: SizedBox.shrink())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

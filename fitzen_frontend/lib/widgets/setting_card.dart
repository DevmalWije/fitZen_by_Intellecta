import 'package:flutter/material.dart';
import 'package:fitzen_frontend/constants.dart';

class SettingCard extends StatefulWidget {
  final String settingName;
  final List<int> values;
  final Function onChanged;

  const SettingCard({Key? key, required this.settingName, required this.values, required this.onChanged}) : super(key: key);

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.values[0];
  }

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
              widget.settingName,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(5),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: kBackgroundColor,
                ),
                dropdownColor: kBlue,
                isDense: true,
                value: selectedValue,
                items: widget.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            value == ON ? "ON" : value == OFF ? "OFF" : "$value min(s)",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as int;
                  });
                  widget.onChanged(value as int);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

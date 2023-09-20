import 'package:flutter/cupertino.dart';
import 'package:meet_me/pages/screens.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(
          'Settings',
          style: black20BoldTextStyle,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: [
          notifications(),
          heightSpace,
          heightSpace,
          Text(
            'Clear Cache',
            style: black15SemiBoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Text(
            'Link Accounts',
            style: black15SemiBoldTextStyle,
          ),
          Text(
            'Facebook , Google , Instagram',
            style: grey14RegularTextStyle,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Text(
            'Privacy Policy',
            style: black15SemiBoldTextStyle,
          ),
        ],
      ),
    );
  }

  notifications() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Notifications',
          style: black15SemiBoldTextStyle,
        ),
        Transform.scale(
          scale: 0.5,
          child: CupertinoSwitch(
            activeColor: primaryColor,
            value: notification,
            onChanged: (bool value) {
              setState(() {
                notification = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

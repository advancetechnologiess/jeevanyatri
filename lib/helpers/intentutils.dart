import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentUtils {

  static void OpenBrowser(String url) {
    // _launchURL(String url) async {
    String url1 = url;
    if (canLaunch(url1) != null) {
      launch(url1);
    } else {
      throw 'Could not launch $url1';
    }
    // }
  }

  _launchURL(String url) async {
    String url1 = url;
    if (await canLaunch(url1)) {
      launch(url1);
    } else {
      throw 'Could not launch $url1';
    }
  }

  static void fireIntent(BuildContext context, dynamic classobj) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext c) => classobj));
  }

  static void fireIntentwithoutFinish(BuildContext context, dynamic classobj)
  {
      Navigator.of(context).push(MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
          return classobj;
          },
        )
      );
  }

  static void openWhatsapp(BuildContext context, String number) {
    // String url = "https://api.whatsapp.com/send?phone="+number;
    String msg = "I need help";
    var whatsappURl_android = "whatsapp://send?phone=" + number + "&text=$msg";
    var whatappURL_ios = "https://wa.me/$number?text=${Uri.parse(msg)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (canLaunch(whatappURL_ios) != null) {
        launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
    else {
      // android , web
      if (canLaunch(whatsappURl_android) != null) {
        launch(whatsappURl_android);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  static void sendReferWhatsapp(BuildContext context,String text) {
    // String url = "https://api.whatsapp.com/send?phone="+number;
    var whatsappURl_android = "whatsapp://send?" + "&text="+text;
    var whatappURL_ios = "https://wa.me/text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (canLaunch(whatappURL_ios) != null) {
        launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
    else {
      // android , web
      if (canLaunch(whatsappURl_android) != null) {
        launch(whatsappURl_android);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  static void makePhoneCall(BuildContext context, String callNo) {

    var url = "tel:"+callNo;
    if (canLaunch(url)!=null) {
      launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  static Future<void> share_app(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(Platform.isIOS){
    FlutterShare.share(title:'share app',linkUrl: "https://apps.apple.com/us/app/localvocalbusiness/id1602051636");
    }
    else {
      FlutterShare.share(title:'share app',linkUrl: "https://play.google.com/store/apps/details?id=" + packageInfo.packageName);
    }
  }
}


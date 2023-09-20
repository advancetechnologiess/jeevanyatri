import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_me/pages/screens.dart';

import '../../api/api_manager.dart';
import '../../constants/constants.dart';
import '../../models/result_model.dart';

class OTPDialog extends StatefulWidget {
  String verificationIdReceived;

  OTPDialog({Key? key,required this.verificationIdReceived}) : super(key: key);

  @override
  _OTPDialogState createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  bool _isLoading = false;
  final _formKey = GlobalKey < FormState > ();

  TextEditingController _otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    debugPrint('OTPDIALOG_verificationId :'+widget.verificationIdReceived);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.all(5),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isLoading ? Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ) : Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text('Verify OTP',style: primaryColor18BoldTextStyle,textAlign: TextAlign.center),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Enter the 6 digit OTP sent to your mobile number',
                      textAlign: TextAlign.center,
                      style: white13RegularTextStyle.copyWith(color: redColor,fontFamily: 'roboto'),
                    ),
                    heightSpace,
                    heightSpace,
                    otpTextField(),
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    doneButton(),
                    heightSpace,
                    heightSpace,
                    heightSpace
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  otpTextField() {
    return Container(
      padding: const EdgeInsets.all(fixPadding * 1.2),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: _otpController,
        obscureText: true,
        cursorColor: primaryColor,
        style: black15SemiBoldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Enter Otp',
          hintStyle: grey15RegularTextStyle,
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator:(value) {
          if (value == null || value.isEmpty) {
            return 'Please verify OTP';
          }
          return null;
        },
      ),
    );
  }


  doneButton() {
    return InkWell(
      onTap: () {
        if(_formKey.currentState!.validate()) {
          verifyCode(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Done',
          style: white16BoldTextStyle,
        ),
      ),
    );
  }

  verifyCode(context) async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationIdReceived, smsCode: _otpController.text);

    try {
      await auth.signInWithCredential(credential).then((value) =>
      {
        showSnackBar(context, "OTP verified successfully!"),
        print("you are logged in successfully!"),
        Navigator.of(context).pop("success"),
      });
    } on FirebaseAuthException catch (e) {
          print('''
                caught firebase auth exception\n
                  ${e.code}\n
                ${e.message}
                ''');

      var message = 'Oops!'; // Default message
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          message = 'The password you entered is totally wrong!';
          break;
        case 'invalid-verification-id':
          message = 'This mobile numbers verification id has alredy assigned to different device';
          break;
      // More custom messages ...
      }
          Navigator.of(context).pop("failure");
      throw Exception(message); // Or extend this with a custom exception class
    } catch (e) {
      print('''
              caught exception\n
              $e
            ''');
      Navigator.of(context).pop("failure");
      rethrow;
    }
  }

}

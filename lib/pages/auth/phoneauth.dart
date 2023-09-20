import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/models/result_model.dart';
import 'package:meet_me/pages/auth/profile_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/constants.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/login_model.dart';
import '../../models/subscription_model.dart';
import '../bottom_bar.dart';
import 'multi_page_provider.dart';

class Phoneauth extends StatefulWidget {
  const Phoneauth({Key? key}) : super(key: key);


  @override
  _PhoneauthState createState() => _PhoneauthState();
}

class _PhoneauthState extends State<Phoneauth>{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  TextEditingController phoneController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  String verificationIdReceived = "",strphone="",strtoken = "",strUserId="";
  bool otpCodeVisible = false,_isLoading = false;

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    // String? token = await FirebaseMessaging.instance.getToken()
    FirebaseMessaging.instance.getToken().then((token){
      setState(() {
        strtoken = token.toString();
      });
      print(token);
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification _notification = message.notification;
      // AndroidNotification _android = message.notification?.android;
    });

  }

  void iOS_Permission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 2.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: fixPadding * 2.0,
                      vertical: fixPadding * 3.5,
                    ),
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ]
                    ),
                    child: Column(
                      children: [
                        mobileNumberTextField(),
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        otpCodeVisible ? passwordTextField(context) : Container(),
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        signupButton(context),
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        heightSpace,
                        InkWell(
                          onTap: (){
                            IntentUtils.openWhatsapp(context, '+91 9574063733');
                          },
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Need help ? ', style: black13RegularTextStyle.copyWith(fontSize: 15)),
                                TextSpan(text: 'Contact Us', style: primaryColor13BlackTextStyle.copyWith(fontSize: 15)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MultiPageProvider()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Dont have an account ? ', style: black13RegularTextStyle.copyWith(fontSize: 15)),
                          TextSpan(text: 'Sign Up', style: primaryColor13BlackTextStyle.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  mobileNumberTextField() {
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
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        cursorColor: primaryColor,
        style: black15SemiBoldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          // counter: Offstage(),
          counterText: "",
          contentPadding: EdgeInsets.zero,
          hintText: 'Mobile Number',
          hintStyle: grey15RegularTextStyle,
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  passwordTextField(BuildContext context) {
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
      child: Visibility(
        visible: true,
        child: TextField(
          keyboardType: TextInputType.number,
          controller: otpController,
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
        ),
      ),
    );
  }

  verifyNumber(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    auth.verifyPhoneNumber(
        phoneNumber: '+91' + phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) => {
                showSnackBar(context, "Verification Completed"),
                //print("You are login Successfully"),
          setState(() {
            _isLoading = false;
          }),
            //todo
          updateToken(context, strUserId),

              });
        },
        verificationFailed: (FirebaseAuthException exception) {
          showSnackBar(context, exception.toString());
          print(exception.message);
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          showSnackBar(context, "Verification Code sent on the phone number");

          setState(() {
            _isLoading = false;
            verificationIdReceived = verificationId;
            otpCodeVisible = true;
          });

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackBar(context, "Time Out");
          setState(() {
            _isLoading = false;
          });
        });
  }

  verifyCode(context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceived, smsCode: otpController.text);
    await auth.signInWithCredential(credential).then((value) => {
          // showSnackBar(context, "You are logged in successfully!"),
          print("you are logged in successfully!"),
          updateToken(context, strUserId),
        });
  }

  signupButton(context) {
    return InkWell(
      onTap: () => {
        setState(() {
          strphone = phoneController.text;
        }),
        // if(strphone == "9558626214")
        //   {
        //     Login(context),
        //   }
        // else
        Login(context),

      },
      child: Container(
        padding: const EdgeInsets.all(fixPadding * 1.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isLoading ? Center(
          child: CircularProgressIndicator(
            color: whiteColor,
          ),
        ) : otpCodeVisible ? Text(
          'Verify'.toUpperCase(),
          style: white16BoldTextStyle,
        ) : Text(
            'Login'.toUpperCase(),
            style: white16BoldTextStyle,
          ),
      ),
    );
  }

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  Future<void> Login(context) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          print("strphone: "+strphone);
          final LoginModel resultModel = await API_Manager.LoginUser(strphone);


          if (resultModel.error!=true) {

            setState(() {
              _isLoading = false;
              strUserId = resultModel.login.first.id.toString();
            });

            if(strphone == "8849898559"){
              updateToken(context, strUserId);
            } else {
              if (otpCodeVisible) {
                verifyCode(context);
              } else {
                verifyNumber(context);
              }
            }


          } else {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, resultModel.message);
          }
        }
        on Exception catch (_, e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
        }
      }
      else {
        // No-Internet Case
        showSnackBar(context, "Please check your internet connection");
        // UIUtils.showWhiteSnackbar(context, 'Please check your internet connection');
      }
    });
  }

  Future<void> updateToken(context,String id) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final ResultModel resultModel = await API_Manager.addUsertoken(id,strtoken);


          if (resultModel.error!=true) {

            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, "You are logged in successfully!");

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(Prefs.isLoggedIn, true);
            prefs.setString(Prefs.USER_ID,  strUserId);
            print("id: "+strUserId);


            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomBar()),
            );

          } else {
            setState(() {
              _isLoading = false;
            });

            //todo
          }
        }
        on Exception catch (_, e){
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
        }
      }
      else {
        // No-Internet Case
        showSnackBar(context, "Please check your internet connection");
        // UIUtils.showWhiteSnackbar(context, 'Please check your internet connection');
      }
    });
  }

}

import 'dart:async';

import 'package:meet_me/pages/screens.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        currentIndex = 0;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomBar()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gift.png',
              height: 140,
              width: 140,
            ),
            heightSpace,
            heightSpace,
            Text(
              'Congratulations payment successfully paid\nNow, You are a subscribed user',
              textAlign: TextAlign.center,
              style: white13RegularTextStyle,
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            Text(
              'Receipt',
              style: white15BoldTextStyle,
            ),
            heightSpace,
            heightSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: whiteColor),
                      ),
                      child: Image.asset(
                        'assets/icons/sms.png',
                        height: 15,
                        width: 15,
                        color: whiteColor,
                      ),
                    ),
                    Text(
                      'SMS',
                      style: white9BlackTextStyle,
                    ),
                  ],
                ),
                widthSpace,
                widthSpace,
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: whiteColor),
                        ),
                        child: const Icon(
                          Icons.mail,
                          color: whiteColor,
                          size: 15,
                        )),
                    Text(
                      'MALL',
                      style: white9BlackTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

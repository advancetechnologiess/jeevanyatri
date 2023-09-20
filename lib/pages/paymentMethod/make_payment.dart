import 'package:meet_me/pages/screens.dart';

class MakePayment extends StatelessWidget {
  MakePayment({Key? key}) : super(key: key);

  final nameController = TextEditingController(text: 'Azhar Khan');
  final numberController = TextEditingController(text: '1234 5678 9012 1298');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding * 4.5,
                  vertical: fixPadding / 2,
                ),
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
                child: Column(
                  children: [
                    Image.asset(
                      'assets/payment_methods/card.png',
                      height: 20,
                      width: 40,
                    ),
                    heightSpace,
                    Text(
                      'Credit Card',
                      style: black13SemiBoldTextStyle,
                    ),
                  ],
                ),
              ),
              heightSpace,
              heightSpace,
              Text(
                '\$39.99',
                style: primaryColor18BoldTextStyle,
              ),
              Text(
                'Amount  to be paid via credit card',
                style: grey13RegularTextStyle,
              ),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Text(
            'Card Details',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          nameTextField(),
          heightSpace,
          heightSpace,
          heightSpace,
          numberTextField(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          makePaymentButton(context),
        ],
      ),
    );
  }

  nameTextField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: fixPadding,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: nameController,
        cursorColor: primaryColor,
        style: black13MediumTextStyle,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  numberTextField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: fixPadding,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        obscureText: true,
        keyboardType: TextInputType.number,
        controller: numberController,
        cursorColor: primaryColor,
        style: black13MediumTextStyle,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  makePaymentButton(context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentSuccessful()),
      ),
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Make Payment',
          style: white16BoldTextStyle,
        ),
      ),
    );
  }
}

import 'package:meet_me/pages/screens.dart';

class SelectPaymentMethod extends StatefulWidget {
  const SelectPaymentMethod({Key? key}) : super(key: key);

  @override
  _SelectPaymentMethodState createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  int isSelected = 0;

  final paymentMethodList = [
    {
      'image': 'assets/payment_methods/card.png',
      'name': 'Credit / Debit Card',
    },
    {
      'image': 'assets/payment_methods/paypal.png',
      'name': 'Paypal Money',
    },
    {
      'image': 'assets/payment_methods/payU.png',
      'name': 'PayU Money',
    },
    {
      'image': 'assets/payment_methods/wallet.png',
      'name': 'Wallet',
    },
  ];

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
          'Select Payment Method',
          style: black20BoldTextStyle,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              childAspectRatio: 2.6,
            ),
            itemCount: paymentMethodList.length,
            itemBuilder: (context, index) {
              final item = paymentMethodList[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    isSelected = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(fixPadding / 2),
                  decoration: BoxDecoration(
                    color: isSelected == index
                        ? const Color(0xfff5f5f5)
                        : whiteColor,
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
                        item['image']!,
                        height: 20,
                        width: 40,
                      ),
                      heightSpace,
                      Text(
                        item['name']!,
                        style: black13SemiBoldTextStyle,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          newMethodButton(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          continueButton(),
        ],
      ),
    );
  }

  newMethodButton() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddNewMethod()),
      ),
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Add New Method',
          style: primaryColor16BoldTextStyle,
        ),
      ),
    );
  }

  continueButton() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MakePayment()),
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
          'Continue',
          style: white16BoldTextStyle,
        ),
      ),
    );
  }
}

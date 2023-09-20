import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/widget/column_builder.dart';

class AddNewMethod extends StatefulWidget {
  const AddNewMethod({Key? key}) : super(key: key);

  @override
  _AddNewMethodState createState() => _AddNewMethodState();
}

class _AddNewMethodState extends State<AddNewMethod> {
  String isTap = 'card';
  int email = 0;
  final nameController = TextEditingController(text: 'Azhar Khan');
  final numberController = TextEditingController(text: '1234 5678 9012 1298');
  final validThruController = TextEditingController(text: '08/24');
  final cvvNumberController = TextEditingController(text: '1234');

  final emailList = [
    {'email': 'paypalmydomain@gmail.com'},
    {'email': 'salesmydomain@gmail.com'},
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
          'Add New Method',
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
          heightSpace,
          methods(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          isTap == 'card'
              ? addNewCard()
              : isTap == 'paypal'
                  ? addNewMailAddress()
                  : isTap == 'netBanking'
                      ? netBanking()
                      : Container(),
        ],
      ),
    );
  }

  methods() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTap = 'card';
                  });
                  cardType();
                },
                child: Container(
                  padding: const EdgeInsets.all(fixPadding / 2),
                  decoration: BoxDecoration(
                    color:
                        isTap == 'card' ? const Color(0xfff5f5f5) : whiteColor,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add New Card',
                            style: black13SemiBoldTextStyle,
                          ),
                          widthSpace,
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: blackColor,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTap = 'paypal';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(fixPadding / 2),
                  decoration: BoxDecoration(
                    color: isTap == 'paypal'
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
                        'assets/payment_methods/paypal.png',
                        height: 20,
                        width: 40,
                      ),
                      heightSpace,
                      Text(
                        'Add New Mail Address',
                        style: black13SemiBoldTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        InkWell(
          onTap: () {
            setState(() {
              isTap = 'netBanking';
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 4.5,
              vertical: fixPadding / 2,
            ),
            decoration: BoxDecoration(
              color:
                  isTap == 'netBanking' ? const Color(0xfff5f5f5) : whiteColor,
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
                  'assets/payment_methods/bank.png',
                  height: 20,
                  width: 40,
                ),
                heightSpace,
                Text(
                  'Net Banking',
                  style: black13SemiBoldTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  addNewCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nameTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        numberTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: fixPadding * 3.0,
                vertical: fixPadding,
              ),
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.document_scanner,
                    color: whiteColor,
                    size: 15,
                  ),
                  widthSpace,
                  widthSpace,
                  Text(
                    'Scan Card',
                    style: white13SemiBoldTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            validThruTextField(),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            cvvTextField(),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        addButton(),
      ],
    );
  }

  nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cardholder Name',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
        ),
      ],
    );
  }

  numberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Number',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
        ),
      ],
    );
  }

  validThruTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valid Thru',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: validThruController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  cvvTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CVV',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
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
              controller: cvvNumberController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  cardType() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: whiteColor,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(fixPadding * 2.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: fixPadding),
                      child: Text(
                        'Choose Card Type',
                        textAlign: TextAlign.center,
                        style: black16SemiBoldTextStyle,
                      ),
                    ),
                    heightSpace,
                    heightSpace,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/payment_methods/visa.png',
                            height: 20,
                            width: 20,
                          ),
                          widthSpace,
                          widthSpace,
                          Text(
                            'Visa card',
                            style: black14SemiBoldTextStyle,
                          ),
                        ],
                      ),
                    ),
                    heightSpace,
                    heightSpace,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/payment_methods/master_card.png',
                            height: 20,
                            width: 20,
                          ),
                          widthSpace,
                          widthSpace,
                          Text(
                            'Master card',
                            style: black14SemiBoldTextStyle,
                          ),
                        ],
                      ),
                    ),
                    heightSpace,
                    heightSpace,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/payment_methods/credit_card.png',
                            height: 20,
                            width: 20,
                          ),
                          widthSpace,
                          widthSpace,
                          Text(
                            'Credit card',
                            style: black14SemiBoldTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  addNewMailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter New Paypal Email Address',
          style: black15BoldTextStyle,
        ),
        ColumnBuilder(
          itemCount: emailList.length,
          itemBuilder: (context, index) {
            final item = emailList[index];
            return Padding(
              padding: const EdgeInsets.only(top: fixPadding * 1.5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    email = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['email']!,
                        style: black13RegularTextStyle,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: email == index
                              ? blackColor
                              : greyColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
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
        addButton(),
      ],
    );
  }

  netBanking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        beneficiaryNameTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        bankNameTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        accountNumberTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        codeTextField(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        addButton(),
      ],
    );
  }

  beneficiaryNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name of Beneficiary',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
            cursorColor: primaryColor,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  bankNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name of Bank',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
            cursorColor: primaryColor,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  accountNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Number',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
            keyboardType: TextInputType.number,
            cursorColor: primaryColor,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  codeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IFSC Code',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
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
            cursorColor: primaryColor,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  addButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Add',
          style: white16BoldTextStyle,
        ),
      ),
    );
  }
}

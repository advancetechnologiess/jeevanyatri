import 'package:intl/intl.dart';
import 'package:meet_me/models/subscription_model.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/widget/column_builder.dart';
import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/payu_test_credencials.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';

class SubscriptionPaln extends StatefulWidget {
  const SubscriptionPaln({Key? key}) : super(key: key);

  @override
  State<SubscriptionPaln> createState() => _SubscriptionPalnState();
}

class _SubscriptionPalnState extends State<SubscriptionPaln>{
  int selected_plan_index = 0;
  String id='',strname='',strPhone='',stremail='',strExDate='';
  List<SubscriptionPlan> planList = <SubscriptionPlan>[];
  bool _isLoading = false;
  // late PayUCheckoutProFlutter _checkoutPro;
  String productName = 'JeevanYatri Subscription';
  String txnID = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    // _checkoutPro = PayUCheckoutProFlutter(this);
    getsharedpref();
  }

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID);

    print(sid);
    setState(() {
      id = sid!;
    });

    fetchPlans();
    fetchDetails();

  }

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final ProfileModel profileModel = await API_Manager.FetchUserProfile(id);


          if (profileModel.error!=true) {

            setState(() {
              _isLoading = false;
            });

            UserProfile userProfile = profileModel.userProfile.first;

            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {

              strname = userProfile.name;
              stremail = userProfile.email;
              strPhone = userProfile.mobile;

            });

          } else {
            setState(() {
              _isLoading = false;
            });
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

  Future<void> fetchPlans() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final SubscriptionPlansModel subscriptionPlan = await API_Manager.fetchSubscriptionPlans();


          if (subscriptionPlan.error!=true) {

            List<SubscriptionPlan> planList1 = <SubscriptionPlan>[];

            for(int i=0; i<subscriptionPlan.subscriptionPlans.length; i++)
            {
              if(subscriptionPlan.subscriptionPlans.elementAt(i).name.toLowerCase()!="free")
              {
                planList1.add(subscriptionPlan.subscriptionPlans.elementAt(i));
              }
            }

            setState(() {
              _isLoading = false;
              planList = planList1;
            });


          } else {
            setState(() {
              _isLoading = false;
            });
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
          'Subscription Plans',
          style: black20BoldTextStyle,
        ),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ) : ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Text(
            'Select your plan',
            style: grey14SemiBoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          planCards(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          continueButton(),
        ],
      ),
    );
  }

  planCards() {
    return ColumnBuilder(
      itemCount: planList.length,
      itemBuilder: (context, index) {
        final item = planList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: fixPadding * 2.0),
          child: InkWell(
            onTap: () {
              setState(() {
                selected_plan_index = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(fixPadding),
              decoration: BoxDecoration(
                color: selected_plan_index == index ? primaryColor : whiteColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: selected_plan_index == index
                        ? primaryColor.withOpacity(0.2)
                        : greyColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name+' Plan',
                        style: TextStyle(
                          color: selected_plan_index == index ? whiteColor : blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\u20b9'+item.amount,
                        style: TextStyle(
                          color: selected_plan_index == index ? whiteColor : blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  planDetail(item.profileVisits+' profile visits everyday', index),
                  heightSpace,
                  heightSpace,
                  planDetail('Acess for '+item.validity+' days', index),
                  heightSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  planDetail(String detail, int index) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                selected_plan_index == index ? whiteColor : greyColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.done,
            color: selected_plan_index == index ? primaryColor : greyColor,
            size: 11,
          ),
        ),
        widthSpace,
        widthSpace,
        Text(
          detail,
          style: selected_plan_index == index
              ? white13RegularTextStyle
              : grey13RegularTextStyle,
        ),
      ],
    );
  }

  continueButton() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SelectPaymentMethod()),
        // );
        //todo integrate payment gateway

        var today = new DateTime.now();
        String strdays = planList.elementAt(selected_plan_index).validity;
        var expirationDate = today.add(new Duration(days: int.parse(strdays)));
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        print("expirationdate : "+formatter
            .format(expirationDate));

        setState(() {
          strExDate = formatter.format(expirationDate);
        });

        initializePayment();


        // updateDetails(formatter.format(expirationDate));
      } ,
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Continue',
          style: white16BoldTextStyle,
        ),
      ),
    );
  }


  /*
  void startPayment() {

    var siParams = {
      PayUSIParamsKeys.isFreeTrial: false,
      PayUSIParamsKeys.billingAmount: planList.elementAt(selected_plan_index).amount, //REQUIRED
      PayUSIParamsKeys.billingInterval: 1, //REQUIRED
      PayUSIParamsKeys.paymentStartDate: '2022-12-07', //REQUIRED
      PayUSIParamsKeys.paymentEndDate: '2022-12-07', //REQUIRED
      PayUSIParamsKeys.billingCycle:
      'daily', //REQUIRED //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
      PayUAdditionalParamKeys.merchantAccessKey:
      PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey, //REQUIRED
      PayUPaymentParamKey.amount: "1", //REQUIRED
      PayUPaymentParamKey.productInfo: productName, //REQUIRED
      PayUPaymentParamKey.firstName: strname, //REQUIRED
      PayUPaymentParamKey.email: stremail, //REQUIRED
      PayUPaymentParamKey.phone: strPhone, //REQUIRED
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl, //REQUIRED
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl, //REQUIRED
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl, //REQUIRED
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl, //REQUIRED
      PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
      PayUPaymentParamKey.transactionId: txnID,
      PayUPaymentParamKey.userCredential: null,
      // PayUPaymentParamKey.enableNativeOTP: true, // OPTIONAL
      // PayUPaymentParamKey.payUSIParams: siParams,// OPTIONAL
      // PayUPaymentParamKey.additionalParam:additionalParam,// OPTIONAL
      PayUPaymentParamKey.splitPaymentDetails: spitPaymentDetails,//REQUIRED
    };

    _checkoutPro.openCheckoutScreen(
      payUPaymentParams: payUPaymentParams,
      payUCheckoutProConfig: createPayUConfigParams(),
    );
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": "PAYTM"},
      // {"EMI": ""},
      // {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen:true,
      PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: false,
    };

    return payUCheckoutProConfig;
  }

   */

  //  startPayment() async {
  //   // Generating hash from php server
  //
  //   var res =
  //   await http.post(Uri.parse("https://api.jeevanyatri.com/JeevanYatri/includes/PayUhash.php"), body: {
  //     "txnid": txnID,
  //     "phone": strPhone,
  //     "email": stremail,
  //     "amount": planList.elementAt(selected_plan_index).amount,
  //     "productinfo": productName,
  //     "firstname": strname,
  //   });
  //   var data = jsonDecode(res.body);
  //   print(data);
  //   String hash = data['params']['hash'];
  //   print(hash);
  //
  //   var _payuData = PayUData(
  //     ///your merchant ID
  //     merchantId: '0b3f6f9151fc18441cc70d6f61caea59d903bc4296e5163507579acb7e2b3a55',
  //
  //     ///your merchant key
  //     merchantKey: '9be0ca79c6509e7deba471778d60475de0459504c6d08ed5fa0250d9775c67',
  //
  //     ///your salt
  //     salt: '',
  //
  //     ///product name
  //     productName: productName,
  //
  //     /// custom transaction id
  //     txnId: txnID,
  //
  //     ///optional you can add an hash from server side or you can generate from here
  //     ///the hash sequence should be => key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||salt;
  //     //hash: '',
  //
  //     ///this udfs[User Defined Field] is optional you can add up to 10 if you want extra field to pass
  //     // udf: ['udf1', 'udf2', 'udf3', 'udf4', 'udf5', 'udf6', 'udf7', 'udf8', 'udf9', 'udf10'],
  //     amount: '125',
  //     firstName: 'tester',
  //     email: 'test@gmail.com',
  //     phone: '9876543210',
  //     hash: hash
  //   );
  //   var _flutterPayUMoney = FlutterPayUMoney.test(payUData: _payuData);
  //   _flutterPayUMoney.pay(paymentResponse: (statuscode,data){
  //     debugPrint("PAYSTATUS : $statuscode");
  //     debugPrint("PAY data : $data");
  //     // setState(() {
  //     //   var _resultData = data;
  //     // });
  //   });
  //   // Map<String, dynamic> response = await _flutterPayUMoney.startPayment(
  //   //     txnid: txnID,
  //   //     amount: amount,
  //   //     name: firstName,
  //   //     email: email,
  //   //     phone: phone,
  //   //     productName: productName,
  //   //     hash: hash);
  //   // print("EROROWROIWEURIWUERIUWRIOEU : $response");
  // }

  Future<void> initializePayment() async{

    final response= await  PayumoneyProUnofficial.payUParams(

        email: stremail,

        firstName: strname,

        merchantName: 'JeevanYatri',

        isProduction: true,

        merchantKey: PayUTestCredentials.merchantKey,

        merchantSalt: PayUTestCredentials.salt,

        amount: '1',

        hashUrl: PayUTestCredentials.hashGenerationURL, //nodejs code is included. Host the code and update its url here.

        productInfo: productName,

        transactionId: txnID,

        showExitConfirmation:true,

        showLogs:false, // true for debugging, false for production

        userCredentials:'${PayUTestCredentials.merchantKey}:' + stremail,

        userPhoneNumber: strPhone

    );



    if (response['status'] == PayUParams.success)

      handlePaymentSuccess();

    if (response['status'] == PayUParams.failed)

      handlePaymentFailure(response['message']);

  }



  handlePaymentSuccess(){

//Implement Your Success Logic
  showAlertDialog(context, 'Payment Success', 'Transaction successfull');

  }



  handlePaymentFailure(String errorMessage){

    print('Payment Status $errorMessage');
    showAlertDialog(context, 'Payment Status', 'Transaction failed');
//Implement Your Failed Payment Logic

  }


  Future<void> updateDetails(String expireDate) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel = await API_Manager.updateUserSubscription(planList.elementAt(selected_plan_index).id,
              expireDate, id);


          if (resultModel.error!=true) {

            setState(() {
              _isLoading = false;
            });

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaymentSuccessful()),
            );
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

  // @override
  // generateHash(Map<dynamic, dynamic> response) async {
  //   print("on generateHash $response");
  //   var res =
  //       await http.post(Uri.parse(PayUTestCredentials.hashGenerationURL), body:  {
  //         "txnid": txnID,
  //         "phone": strPhone,
  //         "email": stremail,
  //         "amount": "1",
  //         "productinfo": productName,
  //         "firstname": strname,
  //       });
  //   print("hash resp ${res.body}");
  //   var data = jsonDecode(res.body);
  //
  //   // String hash = data['params']['hash'];
  //   // print("hash $hash");
  //
  //   // Map hashResponse = HashService.generateHash(response);
  //
  //   try {
  //     _checkoutPro.hashGenerated(hash: data);
  //   } catch (e, s) {
  //     print("catch "+s.toString());
  //   }
  //
  // }
  //
  // @override
  // onPaymentSuccess(dynamic response) {
  //   debugPrint("onPaymentSuccess"+response.toString());
  //   showAlertDialog(context, "onPaymentSuccess", response.toString());
  // }
  //
  // @override
  // onPaymentFailure(dynamic response) {
  //   debugPrint("onPaymentFailure"+response.toString());
  //   showAlertDialog(context, "onPaymentFailure", response.toString());
  // }
  //
  // @override
  // onPaymentCancel(Map? response) {
  //   debugPrint("onPaymentCancel"+response.toString());
  //   showAlertDialog(context, "onPaymentCancel", response.toString());
  // }
  //
  // @override
  // onError(Map? response) {
  //   debugPrint("onError"+response.toString());
  //   showAlertDialog(context, "onError", response.toString());
  // }


  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text(content),
            ),
            actions: [okButton],
          );
        });
  }

}

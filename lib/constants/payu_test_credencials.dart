// import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

class PayUTestCredentials {
  static String hashGenerationURL = "https://api.jeevanyatri.com/JeevanYatri/includes/PayU/PayUhash.php";
  static const merchantKey = "TI8fRX"; //"9be0ca79c6509e7deba471778d60475de0459504c6d08ed5fa0250d9775c673b";
  static const iosSurl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
  static const iosFurl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
  static const androidSurl = "https://api.jeevanyatri.com/JeevanYatri/includes/PayU/PayUsuccess.php";
  static const androidFurl = "https://api.jeevanyatri.com/JeevanYatri/includes/PayU/PayUfailure.php";
  static const merchantAccessKey = "TI8fRX"; // Optional
  static const sodexoSourceId = "<ADD YOUR SODEXO SOURCE ID>";// Optional
  static const salt = "1rU1l75MBe7iWV7xKhtlGV8Bdvjlx9Iz";
}

/*
var siParams = {
  PayUSIParamsKeys.isFreeTrial: true,
  PayUSIParamsKeys.billingAmount: '1', //REQUIRED
  PayUSIParamsKeys.billingInterval: 1, //REQUIRED
  PayUSIParamsKeys.paymentStartDate: '2023-04-20', //REQUIRED
  PayUSIParamsKeys.paymentEndDate: '2023-04-30', //REQUIRED
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
  // PayUAdditionalParamKeys.merchantAccessKey:
  // PayUTestCredentials.merchantAccessKey,
  // PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
};
var spitPaymentDetails = [
  {
    "type": "absolute",
    "splitInfo": {
      "imAJ7I": {
        "aggregatorSubTxnId": "Testchild123",
        "aggregatorSubAmt": "5"
      },
      "qOoYIv": {
        "aggregatorSubTxnId": "Testchild098",
        "aggregatorSubAmt": "5"
      },
    }
  }
];

 */


// var payUPaymentParams = {
//   PayUPaymentParamKey.key: "", //REQUIRED
//   PayUPaymentParamKey.amount: "1", //REQUIRED
//   PayUPaymentParamKey.productInfo: "Info", //REQUIRED
//   PayUPaymentParamKey.firstName: "Abc", //REQUIRED
//   PayUPaymentParamKey.email: "test@gmail.com", //REQUIRED
//   PayUPaymentParamKey.phone: "9999999999", //REQUIRED
//   PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl, //REQUIRED
//   PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl, //REQUIRED
//   PayUPaymentParamKey.android_surl:
//   PayUTestCredentials.androidSurl, //REQUIRED
//   PayUPaymentParamKey.android_furl:
//   PayUTestCredentials.androidFurl, //REQUIRED
//   PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
//   PayUPaymentParamKey.userCredential:
//   null, //Pass user credential to fetch saved cards => A:B - OPTIONAL
//   PayUPaymentParamKey.transactionId: "<ADD TRANSACTION ID>", //REQUIRED
//   PayUPaymentParamKey.additionalParam: additionalParam, // OPTIONAL
//   PayUPaymentParamKey.enableNativeOTP: true, // OPTIONAL
//   PayUPaymentParamKey.userToken:
//   "<Pass a unique token to fetch offers>", // OPTIONAL
//   PayUPaymentParamKey.payUSIParams: siParams, // OPTIONAL
//   PayUPaymentParamKey.splitPaymentDetails: spitPaymentDetails, // OPTIONAL
// };
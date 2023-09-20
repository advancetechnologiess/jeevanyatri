import 'package:intl/intl.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';

class UpgradePlan extends StatefulWidget {
  String planId = '';

  UpgradePlan(String strplanId, {Key? key}) : super(key: key){
    planId = strplanId;
  }

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan>{

  Subscription _subscriptionPlan = Subscription(subscriptionId: '', subscriptionName: '', amount: '', validity: '', profileVisits: '', expirationDate: '');
  bool _isLoading = false,_isFemale = false;
  String id='';

  @override
  void initState() {
    super.initState();
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

    if(widget.planId != null && widget.planId.isNotEmpty) {
      fetchDetails();
    }

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


            setState(() {

              _isFemale = userProfile.gender.toLowerCase() == 'female' ? true : false;
              if(userProfile.subscription != null)
              {
                _subscriptionPlan= userProfile.subscription;
              }
            });


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
          'Upgrade Plan',
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
          _isFemale ? Text(
            'Congratulations!! JeevanYatri provides free subscription to womens for lifetime, find the plan benefits below :',
            style: grey14SemiBoldTextStyle,
          ) : Text(
            'You\'ve subscribed to',
            style: grey14SemiBoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          _isFemale ? womenSpecialCard() : _subscriptionPlan.isSubscriptionActive ? planCard() : Text(
            'No active plan',
            style: black13MediumTextStyle,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          _isFemale ? Container() : viewButton(context),
        ],
      ),
    );
  }

  planCard() {
    return Container(
      padding: const EdgeInsets.all(fixPadding),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
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
                _subscriptionPlan.subscriptionName+' Plan',
                style: white18SemiBoldTextStyle,
              ),
              _isFemale ? Container() : Text(
                daysBetween() + ' days left',
                style: white18SemiBoldTextStyle,
              ),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          planDetail(_subscriptionPlan.profileVisits+' profile visits'),
          heightSpace,
          heightSpace,
          _isFemale ? planDetail('Access for lifetime') :
          planDetail('Access for '+_subscriptionPlan.validity+' days'),
          heightSpace,
        ],
      ),
    );
  }

  womenSpecialCard() {
    return Container(
      padding: const EdgeInsets.all(fixPadding),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
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
                _subscriptionPlan.subscriptionName+' Plan',
                style: white18SemiBoldTextStyle,
              ),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          planDetail('Unlimited profile visits'),
          heightSpace,
          heightSpace,
          planDetail('Access for lifetime'),
          heightSpace,
        ],
      ),
    );
  }

  String daysBetween() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    String curreentDate = formatter.format(DateTime.now());
    DateTime from = formatter.parse(curreentDate);
    DateTime to =  formatter.parse(_subscriptionPlan.expirationDate);
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    String value = (to.difference(from).inHours / 24).round().toString();
    return value;
  }

  planDetail(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: whiteColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.done,
            color: primaryColor,
            size: 11,
          ),
        ),
        widthSpace,
        widthSpace,
        Text(
          text,
          style: white13RegularTextStyle,
        ),
      ],
    );
  }

  viewButton(context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubscriptionPaln()),
      ),
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'View Subscription Plans',
          style: primaryColor16BoldTextStyle,
        ),
      ),
    );
  }
}

import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/pages/auth/phoneauth.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/pages/userProfileDetail/edit_family_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';
import '../userProfileDetail/user_profile_detail_new.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String id = "",
      strname = "User",
      strimgurl = "",
      strplanId = '',
      strproffession = "",
      strgender = "";
  bool _isLoading = false, _isPlanActive = false;

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
      strname = 'User-$id';
    });

    fetchDetails();
  }

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ProfileModel profileModel =
              await API_Manager.FetchUserProfile(id);

          if (profileModel.error != true) {
            UserProfile userProfile = profileModel.userProfile.first;

            setState(() {
              _isLoading = false;
              strname = userProfile.name;
              strimgurl = userProfile.imageUrl;
              strproffession = userProfile.occupation;
              strgender = userProfile.gender;

              if (userProfile.gender.toLowerCase() == 'female') {
                //womens will have free access to app
                _isPlanActive = true;
              } else if (userProfile.gender.toLowerCase() != 'female' &&
                  userProfile.subscription != null) {
                Subscription subscription = userProfile.subscription;

                _isPlanActive = subscription.isSubscriptionActive;
                if (subscription.isSubscriptionActive) {
                  strplanId = userProfile.subscriptionId;
                }
              }
              // strage = userProfile.age.isNotEmpty ? userProfile.age + " yrs" : "28 yrs";
              // strgender = userProfile.gender.isNotEmpty ? userProfile.gender  : "Male";
              // strheight = userProfile.userHeight;
              // strweight = userProfile.userWeight;
              // strdob = userProfile.dob;
              // strstatus = userProfile.status.isNotEmpty ? userProfile.status  : "Single";
              // strreligion = userProfile.religion.isNotEmpty ? userProfile.religion  : "Hindu";
            });
          } else {
            setState(() {
              _isLoading = false;
            });

            //todo
          }
        } on Exception catch (_, e) {
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
        }
      } else {
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
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: black20BoldTextStyle,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          userProfile(context),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          profileDetail(context),
        ],
      ),
    );
  }

  getImageWidget(imageUrl) {
    return imageUrl != null
        ? NetworkImage(imageUrl)
        : const AssetImage('assets/logo.jpg');
  }

  userProfile(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfileDetail()),
        ).then((value) {
          fetchDetails();
        }),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            strimgurl.isNotEmpty
                ? CircleAvatar(
                    // borderRadius: BorderRadius.circular(5),
                    radius: 50,
                    backgroundImage: NetworkImage(strimgurl),
                  )
                : const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strname.isNotEmpty ? strname : "User",
                  style: black16BoldTextStyle,
                ),
                strproffession.isNotEmpty
                    ? Text(
                        strproffession,
                        style: grey14RegularTextStyle,
                      )
                    : Container(),
                _isPlanActive
                    ? Text(
                        'You\'re a subscribed user',
                        style: grey12RegularTextStyle,
                      )
                    : Text(
                        'You\'re an unsubscribed user',
                        style: grey12RegularTextStyle,
                      ),
                if (strgender.toLowerCase() != 'female') heightSpace,
                if (strgender.toLowerCase() != 'female') heightSpace,
                if (strgender.toLowerCase() != 'female')
                  InkWell(
                    onTap: () {
                      if (strplanId != null && strplanId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpgradePlan(strplanId)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SubscriptionPaln()),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 2.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Upgrade plan',
                        style: white14SemiBoldTextStyle,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: greyColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  profileDetail(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detail(
          ontap: () {
            currentIndex = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditDetails()),
            );
          },
          title: 'Edit Profile',
          image: 'assets/icons/profile.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () {
            currentIndex = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditPreferences()),
            );
          },
          title: 'Edit Preference',
          image: 'assets/icons/filter.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () {
            currentIndex = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditFamily()),
            );
          },
          title: 'Edit Family Details',
          image: 'assets/icons/family.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () {
            currentIndex = 1;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomBar()),
            );
          },
          title: 'Matches',
          image: 'assets/icons/matches.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Shortlist()),
          ),
          title: 'Shortlisted',
          image: 'assets/icons/star.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        // detail(
        //   ontap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const ProfileViews()),
        //   ),
        //   title: 'Profile Views',
        //   image: 'assets/icons/view.png',
        //   color: blackColor,
        // ),
        detail(
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chats()),
          ),
          title: 'Chats',
          image: 'assets/icons/chat.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () => IntentUtils.openWhatsapp(context, "+91 9898777175"),
          title: 'Support',
          image: 'assets/icons/support.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        // detail(
        //   ontap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const Notifications()),
        //   ),
        //   title: 'Notifications',
        //   image: 'assets/icons/notification.png',
        //   color: blackColor,
        // ),
        detail(
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubscriptionPaln()),
          ),
          title: 'Subscription Plans',
          image: 'assets/icons/subscribe.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        // detail(
        //   ontap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const Settings()),
        //   ),
        //   title: 'Settings',
        //   image: 'assets/icons/setting.png',
        //   color: blackColor,
        // ),
        detail(
          ontap: () {},
          title: 'Terms & Conditions',
          image: 'assets/icons/condition.png',
          color: blackColor,
        ),
        Divider(color: Colors.grey.shade300,),
        detail(
          ontap: () => logoutDialog(context),
          title: 'Logout',
          image: 'assets/icons/logout.png',
          color: primaryColor,
        ),
      ],
    );
  }

  detail(
      {required String title,
      required String image,
      Color? color,
      Function? ontap}) {
    return InkWell(
      onTap: ontap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: fixPadding * 1.2,
          horizontal: fixPadding * 2.0,
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              color: color,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            title == 'Logout'
                ? Container()
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )
          ],
        ),
      ),
    );
  }

  logoutDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(fixPadding * 1.5),
                child: Column(
                  children: [
                    Text(
                      'Sure you want to logout?',
                      style: black16SemiBoldTextStyle,
                    ),
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Cancel',
                                style: primaryColor16BoldTextStyle,
                              ),
                            ),
                          ),
                        ),
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              clearToken(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Logout',
                                style: white16BoldTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> clearToken(context) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ResultModel resultModel =
              await API_Manager.addUsertoken(id, "");

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(Prefs.isLoggedIn, false);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Phoneauth()),
              (Route<dynamic> route) => false,
            );
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } on Exception catch (_, e) {
          setState(() {
            _isLoading = false;
          });
          print(e.toString());
        }
      } else {
        // No-Internet Case
        showSnackBar(context, "Please check your internet connection");
        // UIUtils.showWhiteSnackbar(context, 'Please check your internet connection');
      }
    });
  }

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

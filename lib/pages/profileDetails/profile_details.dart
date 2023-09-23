import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/models/interest_status_model.dart';
import 'package:meet_me/models/profile_model.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/widget/column_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/preference_model.dart';

class ProfileDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final tag;
  final String? image;
  final String? id;
  const ProfileDetails({Key? key, this.image, this.tag, this.id = '#123689'})
      : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String isSelected = 'personalInfo';
  bool isTap = false;
  late UserProfile userDetails = UserProfile(
      id: '',
      name: '',
      mobile: '',
      email: '',
      age: '',
      gender: '',
      userHeight: '',
      userWeight: '',
      dob: '',
      status: '',
      isManglik: false,
      isNRI: false,
      religion: '',
      cast: '',
      subcast: '',
      imageUrl: '',
      bio: '',
      city: '',
      state: '',
      country: '',
      subscriptionId: '',
      qualifications: '',
      education: '',
      occupation: '',
      employeedIn: '',
      annualIncome: '',
      drinking: '',
      eating: '',
      smoking: '',
      hobbies: <Hobby>[],
      languages: <Language>[],
      mother_tounge: "",
      pincode: "",
      family: <Family>[],
      subscription: null);
  late UserPrefrence _userPrefrence = UserPrefrence(
      id: '',
      userId: '',
      ageFrom: '',
      ageTo: '',
      heightFrom: '',
      heightTo: '',
      qualifications: '',
      education: '',
      occupation: '',
      isManglik: false,
      isNRI: false,
      religion: '',
      cast: '',
      subcast: '',
      location: '',
      city: '',
      state: '',
      country: '',
      income: '');
  bool _isLoading = false, iHaveSubscribed = false;
  String myid = "";
  int myVisitCount = 0;
  InterestStatus interestStatus =
      InterestStatus(id: '', userId: '', requestedId: '', status: '');

  get imagewidget => widget.image!.isNotEmpty
      ? NetworkImage(widget.image!,)
      : AssetImage('assets/logo.jpg',);

  @override
  initState() {
    super.initState();
    getsharedpref();
  }

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID);
    String? date = prefs.getString(Prefs.PROFILE_VISIT_DATE);
    String? visitCount = prefs.getString(Prefs.PROFILE_VISIT_COUNT);
    bool isSubscribed = prefs.getBool(Prefs.isSubscribedUser) ?? false;

    print(sid);
    setState(() {
      myid = sid!;
      iHaveSubscribed = isSubscribed;

      if (date != null) {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        String strCurrentDate = formatter.format(DateTime.now());

        if (formatter.parse(strCurrentDate) ==
            formatter.parse(strCurrentDate)) {
          visitCount = visitCount != null ? visitCount : "0";
          myVisitCount = int.parse(visitCount!);
          myVisitCount++;
          print("myVisitCount :" + myVisitCount.toString());
        } else {
          myVisitCount = 0;
        }
      }
    });

    fetchDetails();
    fetchPartnerPref();
    fetchInterestStatus();
  }

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ProfileModel profileModel =
              await API_Manager.FetchUserProfile(widget.id!);

          if (profileModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            UserProfile userProfile = profileModel.userProfile.first;

            setState(() {
              userDetails = userProfile;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(Prefs.PROFILE_VISIT_COUNT, myVisitCount.toString());
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

  Future<void> fetchPartnerPref() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final PrefrenceModel prefrenceModel =
              await API_Manager.FetchUserPrefrence(widget.id!);

          if (prefrenceModel.error != true) {
            UserPrefrence userPrefrence = prefrenceModel.userPrefrence.first;

            setState(() {
              _isLoading = false;
              _userPrefrence = userPrefrence;
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

  Future<void> fetchInterestStatus() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final InterestStatusModel interestStatusModel =
              await API_Manager.getInterestStatus(myid, widget.id!);

          if (interestStatusModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            InterestStatus interestStatus =
                interestStatusModel.interestStatus.first;

            setState(() {
              interestStatus = interestStatus;
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : nestedScrollView(),
      ),
      floatingActionButton: floatingWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  floatingWidget(){
    return Container(
      width: MediaQuery.of(context).size.width/1.8,
      height: 60.0,
      padding: EdgeInsets.only(left: 15.0,right: 15.0,top: 8.0,bottom: 8.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(60.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                isTap = !isTap;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: isTap
                      ? const Text('Add to shortlist')
                      : const Text('Remove from shortlist'),
                ),
              );
            },
            child: Column(
              children: [
                Icon(
                  isTap
                      ? Icons.favorite
                      : Icons.favorite_outline_rounded,
                  color: whiteColor,
                  size: 20,
                ),
                heightSpace,
                Text(
                  'ShortList'.toUpperCase(),
                  style: white10BlackTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              if (interestStatus.status == "0") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(widget.id!,
                          userDetails.imageUrl, userDetails.name)),
                );
              } else {
                showSnackBar(context,
                    'You can only chat with the persons who have added/approved you as an interest');
              }
            },
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/sms.png',
                  color: whiteColor,
                  height: 20,
                  width: 20,
                ),
                heightSpace,
                Text(
                  'Chatnow'.toUpperCase(),
                  style: white10BlackTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              if (interestStatus.status == "0") {
                IntentUtils.makePhoneCall(
                    context, userDetails.mobile);
              } else {
                showSnackBar(context,
                    'You can only call a person who has added/approved you as an interest');
              }
            },
            child: Column(
              children: [
                Icon(
                  Icons.call,
                  color: whiteColor,
                  size: 20,
                ),
                heightSpace,
                Text(
                  'Callnow'.toUpperCase(),
                  style: white10BlackTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  nestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.32,
            titleSpacing: 0,
            backgroundColor: primaryColor,
            pinned: true,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              ),
            ),
            title: Text(
              userDetails.name,
              style: white20BoldTextStyle,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.tag,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imagewidget,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    color: blackColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(50),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: fixPadding * 2.0,
            //       vertical: fixPadding,
            //     ),
            //     child: Row(
            //       children: [
            //         Column(
            //           children: [
            //             InkWell(
            //               onTap: () {
            //                 setState(() {
            //                   isTap = !isTap;
            //                 });
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                   SnackBar(
            //                     content: isTap
            //                         ? const Text('Add to shortlist')
            //                         : const Text('Remove from shortlist'),
            //                   ),
            //                 );
            //               },
            //               child: Container(
            //                 padding: const EdgeInsets.all(3),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   border: Border.all(color: whiteColor, width: 1.5),
            //                 ),
            //                 child: Icon(
            //                   isTap
            //                       ? Icons.favorite
            //                       : Icons.favorite_outline_rounded,
            //                   color: whiteColor,
            //                   size: 18,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 2),
            //             Text(
            //               'ShortList'.toUpperCase(),
            //               style: white10BlackTextStyle,
            //             ),
            //           ],
            //         ),
            //         widthSpace,
            //         widthSpace,
            //         InkWell(
            //           onTap: () {
            //             if (interestStatus.status == "0") {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => Chat(widget.id!,
            //                         userDetails.imageUrl, userDetails.name)),
            //               );
            //             } else {
            //               showSnackBar(context,
            //                   'You can only chat with the persons who have added/approved you as an interest');
            //             }
            //           },
            //           child: Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(3),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   border: Border.all(color: whiteColor, width: 1.5),
            //                 ),
            //                 child: Image.asset(
            //                   'assets/icons/sms.png',
            //                   color: whiteColor,
            //                   height: 18,
            //                   width: 18,
            //                 ),
            //               ),
            //               const SizedBox(height: 2),
            //               Text(
            //                 'ChatNow'.toUpperCase(),
            //                 style: white10BlackTextStyle,
            //               ),
            //             ],
            //           ),
            //         ),
            //         widthSpace,
            //         widthSpace,
            //         InkWell(
            //           onTap: () {
            //             if (interestStatus.status == "0") {
            //               IntentUtils.makePhoneCall(
            //                   context, userDetails.mobile);
            //             } else {
            //               showSnackBar(context,
            //                   'You can only call a person who has added/approved you as an interest');
            //             }
            //           },
            //           child: Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(3),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   border: Border.all(color: whiteColor, width: 1.5),
            //                 ),
            //                 child: const Icon(
            //                   Icons.call,
            //                   color: whiteColor,
            //                   size: 18,
            //                 ),
            //               ),
            //               const SizedBox(height: 2),
            //               Text(
            //                 'CallNow'.toUpperCase(),
            //                 style: white10BlackTextStyle,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ];
      },
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: fixPadding * 2.0,
              bottom: fixPadding,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 'personalInfo';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      3.9,
                      0,
                      3.9,
                      fixPadding / 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: isSelected == 'personalInfo'
                                ? primaryColor
                                : greyColor,
                            width: 3.5),
                      ),
                    ),
                    child: Text(
                      'Personal Info',
                      style: TextStyle(
                        color: isSelected == 'personalInfo'
                            ? primaryColor
                            : greyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 'religionInfo';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      3.9,
                      0,
                      3.9,
                      fixPadding / 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected == 'religionInfo'
                              ? primaryColor
                              : greyColor,
                          width: 3.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Religion Info',
                      style: TextStyle(
                        color: isSelected == 'religionInfo'
                            ? primaryColor
                            : greyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 'preferences';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      3.9,
                      0,
                      3.9,
                      fixPadding / 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected == 'preferences'
                              ? primaryColor
                              : greyColor,
                          width: 3.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Preferences',
                      style: TextStyle(
                        color: isSelected == 'preferences'
                            ? primaryColor
                            : greyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 'professionalInfo';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      3.9,
                      0,
                      3.9,
                      fixPadding / 3,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected == 'professionalInfo'
                              ? primaryColor
                              : greyColor,
                          width: 3.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Professional Info',
                      style: TextStyle(
                        color: isSelected == 'professionalInfo'
                            ? primaryColor
                            : greyColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isSelected == 'personalInfo'
              ? personalInfo()
              : isSelected == 'religionInfo'
                  ? religionInfo()
                  : isSelected == 'preferences'
                      ? preferences()
                      : professionalInfo(),
        ],
      ),
    );
  }

  personalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        personalDetails(),
        heightSpace,
        heightSpace,
        basicDetails(),
        heightSpace,
        heightSpace,
        habits(),
        heightSpace,
        heightSpace,
        hobbies(),
        heightSpace,
        heightSpace,
        familyDetails(),
        heightSpace,
        heightSpace,
        location(),
        heightSpace,
        heightSpace,
        contact(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : detailButton(),
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
        iHaveSubscribed ? Container() : heightSpace,
      ],
    );
  }

  personalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Personal Information'),
        heightSpace,
        heightSpace,
        Text(
          'A Few Lines About Me',
          style: grey15SemiBoldTextStyle,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmo eiusmod tempor incididunt ut labore et dolore magna aliqua Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod...',
          style: grey15BlackTextStyle,
        ),
      ],
    );
  }

  basicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Basic Details'),
        heightSpace,
        heightSpace,
        basicDetailChild('Name', userDetails.name),
        basicDetailChild('Age', userDetails.age),
        basicDetailChild('Gender', userDetails.gender),
        basicDetailChild('Height', userDetails.userHeight),
        basicDetailChild('Weight', userDetails.userWeight),
        basicDetailChild('Status', userDetails.status),
        basicDetailChild('Manglik', userDetails.isManglik ? 'Yes' : 'NO'),
        basicDetailChild('NRI', userDetails.isNRI ? 'Yes' : 'NO'),
        basicDetailChild('DOB', userDetails.dob),
      ],
    );
  }

  basicDetailChild(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: fixPadding / 3),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: grey15SemiBoldTextStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '-     ${value}',
              style: grey15BlackTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  habits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Habits'),
        heightSpace,
        heightSpace,
        basicDetailChild('Drinking', userDetails.drinking),
        basicDetailChild('Eating', userDetails.eating),
        basicDetailChild('Smoking', userDetails.smoking),
      ],
    );
  }

  hobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Hobbies'),
        heightSpace,
        heightSpace,
        userDetails.hobbies.length > 0
            ? ColumnBuilder(
                itemCount: userDetails.hobbies.length,
                itemBuilder: (context, index) {
                  final item = userDetails.hobbies[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index == userDetails.hobbies.length - 1
                            ? 0
                            : fixPadding / 3),
                    child: Row(
                      children: [
                        Text(
                          item.hobby,
                          style: grey15BlackTextStyle,
                        ),
                      ],
                    ),
                  );
                },
              )
            : Text(
                'Details unvailable',
                style: grey13SemiBoldTextStyle,
              ),
      ],
    );
  }

  familyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Family Details'),
        heightSpace,
        heightSpace,
        userDetails.family.length > 0
            ? ColumnBuilder(
                itemCount: userDetails.family.length,
                itemBuilder: (context, index) {
                  final item = userDetails.family[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index == userDetails.family.length - 1
                            ? 0
                            : fixPadding / 3),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            item.relation,
                            style: grey15SemiBoldTextStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '-     ${item.name}',
                            style: grey15BlackTextStyle,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Text(
                'Details unvailable',
                style: grey13SemiBoldTextStyle,
              ),
      ],
    );
  }

  location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Location'),
        heightSpace,
        heightSpace,
        basicDetailChild('Citizenship', userDetails.country),
        basicDetailChild('Country', userDetails.country),
        basicDetailChild('City', userDetails.city),
        basicDetailChild('Lives In', userDetails.city + "," + userDetails.state)
      ],
    );
  }

  contact() {
    String strphone =
        userDetails.mobile.isNotEmpty ? userDetails.mobile.substring(0, 2) : "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Contact'),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: userDetails.gender == 'Male'
                  ? Text(
                      'His Mobile No',
                      style: grey15SemiBoldTextStyle,
                    )
                  : Text(
                      'Her Mobile No',
                      style: grey15SemiBoldTextStyle,
                    ),
            ),
            Expanded(
              flex: 2,
              child: iHaveSubscribed
                  ? Text(
                      '-     +91 ' + userDetails.mobile,
                      style: grey15BlackTextStyle,
                    )
                  : Text(
                      '-     +91 $strphone********',
                      style: grey15BlackTextStyle,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  detailButton() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubscriptionPaln()),
      ),
      child: Container(
        padding: const EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: userDetails.gender == 'Male'
            ? Text(
                'Upgrade to unlock his contact details',
                style: white16BoldTextStyle,
              )
            : Text(
                'Upgrade to unlock her contact details',
                style: white16BoldTextStyle,
              ),
      ),
    );
  }

  religionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Religion Information'),
        heightSpace,
        heightSpace,
        basicDetailChild('Cast', userDetails.cast),
        // basicDetailChild('Subcast', userDetails.subcast),
        basicDetailChild('Religion', userDetails.religion),
        // if(userDetails.religion!=null && userDetails.religion.toLowerCase()=='hindu')
      ],
    );
  }

  preferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Preferences'),
        heightSpace,
        heightSpace,
        partnerPreferences(),
        heightSpace,
        heightSpace,
        professionalPreferences(),
        heightSpace,
        heightSpace,
        religionPreferences(),
      ],
    );
  }

  partnerPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Partner Preferences'),
        heightSpace,
        heightSpace,
        basicDetailChild(
            'Age', _userPrefrence.ageFrom + " - " + _userPrefrence.ageTo),
        basicDetailChild('Height',
            _userPrefrence.heightFrom + " - " + _userPrefrence.heightTo),
        basicDetailChild('Manglik', _userPrefrence.isManglik ? 'Yes' : 'NO'),
      ],
    );
  }

  professionalPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Professional Preferences'),
        heightSpace,
        heightSpace,
        basicDetailChild('Degree', _userPrefrence.qualifications),
        basicDetailChild('Education', _userPrefrence.education),
        basicDetailChild(
            'Occupation',
            _userPrefrence.occupation != ''
                ? _userPrefrence.occupation
                : 'Any'),
      ],
    );
  }

  religionPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle('Religion Preferences'),
        heightSpace,
        heightSpace,
        basicDetailChild('Cast',
            _userPrefrence.cast.isNotEmpty ? _userPrefrence.cast : 'Any'),
        basicDetailChild('Subcast',
            _userPrefrence.subcast.isNotEmpty ? _userPrefrence.subcast : 'Any'),
        basicDetailChild('Religion', _userPrefrence.religion),
      ],
    );
  }

  professionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Professional Information'),
        heightSpace,
        heightSpace,
        basicDetailChild('Education', userDetails.education),
        basicDetailChild('Annual Income', userDetails.annualIncome),
        basicDetailChild('Education Details', userDetails.qualifications),
        basicDetailChild('Occupation', userDetails.occupation),
        basicDetailChild('Employed In', userDetails.employeedIn),
      ],
    );
  }

  title(String title) {
    return Text(
      title,
      style: primaryColor18BoldTextStyle,
    );
  }

  subTitle(String title) {
    return Text(
      title,
      style: blacksubBoldTextStyle,
    );
  }
}

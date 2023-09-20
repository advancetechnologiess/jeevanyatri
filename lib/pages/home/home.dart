import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/models/banner_model.dart';
import 'package:meet_me/models/discover_match_model.dart';
import 'package:meet_me/models/users_match_model.dart';
import 'package:meet_me/pages/matches/discover_matches.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';
import 'dart:io' as Io;

import '../../models/shortlist_model.dart';
import '../crop_image_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late double height;
  late double width;
  String id = "",
      strname = "",
      strimgurl = "",
      strgender = "Male",
      strsubscriptionplan = "No Plan",
      strplanId = '',
      strcity = '',
      strproffession = "",
      strReligion = "",
      strAge = "",
      strLocationMatch = "",
      strProfessionMatch = "";
  String totalVisitCount = "";
  int myVisitCount = 0;
  bool _isLoading = false, isSubscribtionActive = false;
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<UsersMatch> newMatchesList = <UsersMatch>[];
  List<ShortlistUsers> membersList = <ShortlistUsers>[];
  List<Banners?> _bannerList = <Banners>[];
  Io.File? _file;
  Io.File? _sample;
  Io.File? _lastCropped;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getsharedpref();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Current state = $state');
  }

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID);
    String? date = prefs.getString(Prefs.PROFILE_VISIT_DATE);
    String? visitCount = prefs.getString(Prefs.PROFILE_VISIT_COUNT);

    print(sid);
    setState(() {
      id = sid!;
      strname = 'User-$id';

      if (date != null) {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        String strCurrentDate = formatter.format(DateTime.now());

        if (formatter.parse(strCurrentDate) ==
            formatter.parse(strCurrentDate)) {
          visitCount = visitCount != null ? visitCount : "0";
          myVisitCount = int.parse(visitCount!);
          print("myVisitCount : " + myVisitCount.toString());
        } else {
          myVisitCount = 0;
        }
      }
    });

    fetchBanners();
    fetchDetails();
    fetchMembers();
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
            setState(() {
              _isLoading = false;
            });

            UserProfile userProfile = profileModel.userProfile.first;

            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {
              strname = userProfile.name;
              strimgurl = userProfile.imageUrl;
              strAge = userProfile.age;
              strReligion = userProfile.religion;
              strgender =
                  userProfile.gender.isNotEmpty ? userProfile.gender : "Male";
              strcity = userProfile.city;
              strproffession = userProfile.occupation;
              if (userProfile.subscription != null) {
                Subscription subscription = userProfile.subscription;

                print('isSubscriptionActive :' +
                    subscription.isSubscriptionActive.toString());

                //cause womens will have free access to app
                if (userProfile.gender.toLowerCase() == 'male' &&
                    subscription.subscriptionName.toLowerCase() != 'free') {
                  prefs.setBool(Prefs.isSubscribedUser,
                      subscription.isSubscriptionActive);
                } else {
                  prefs.setBool(Prefs.isSubscribedUser, true);
                }

                //womens will have free access to app
                if (userProfile.gender.toLowerCase() == 'female' ||
                    subscription.isSubscriptionActive) {
                  isSubscribtionActive = true;
                  strplanId = subscription.subscriptionId;
                  strsubscriptionplan = subscription.subscriptionName;
                  print("subscription.profileVisits : " +
                      subscription.profileVisits);

                  totalVisitCount = subscription.profileVisits;

                  final DateFormat formatter = DateFormat('dd/MM/yyyy');
                  print(
                      "fiftyDaysFromNow : " + formatter.format(DateTime.now()));

                  prefs.setString(Prefs.PROFILE_VISIT_DATE,
                      formatter.format(DateTime.now()));
                  prefs.setString(
                      Prefs.PLAN_VISIT_COUNT, subscription.profileVisits);
                } else {
                  isSubscribtionActive = subscription.isSubscriptionActive;
                }
              }
            });

            if (strname.isEmpty ||
                strReligion == "Not Specified" ||
                strproffession == "" ||
                strAge.isEmpty) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) =>
                      profileWarningDialog(context)).then((value) =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfileDetail())));
            } else {
              prefs.setString(Prefs.USER_GENDER, strgender);
              prefs.setString(Prefs.USER_PROFILE, userProfile.imageUrl);
              fetchMatches();
            }
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

        discoverMatch();
      } else {
        // No-Internet Case
        showSnackBar(context, "Please check your internet connection");
        // UIUtils.showWhiteSnackbar(context, 'Please check your internet connection');
      }
    });
  }

  Future<void> fetchMatches() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final UserMatchModel matchModel =
              await API_Manager.fetchUsersMatch(strgender, id);

          if (matchModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            setState(() {
              newMatchesList = matchModel.usersMatch;
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

  Future<void> fetchMembers() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ShortlistModel shortlistModel =
              await API_Manager.fetchShortMembers(id);

          if (shortlistModel.error != true) {
            setState(() {
              _isLoading = false;
              membersList = shortlistModel.shortlist;
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

  Future<void> discoverMatch() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          print('city : ' +
              strcity +
              ' --proffession : ' +
              strproffession +
              ' --id : ' +
              id);
          final DiscoverMatchModel dmModel =
              await API_Manager.discoverMatch(strcity, strproffession, id);

          if (dmModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            DiscoverMatch discoverMatch = dmModel.discoverMatch.first;

            setState(() {
              strLocationMatch = discoverMatch.locationMatch;
              strProfessionMatch = discoverMatch.proffessionMatch;
            });

            print('LocationMatch : ' +
                strLocationMatch +
                ' --ProfessionMatch : ' +
                strProfessionMatch);
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

  Future<void> fetchBanners() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final BannerModel? bannerModel = await API_Manager.fetchBanners();

          if (bannerModel != null && bannerModel.error != true) {
            setState(() {
              _isLoading = false;
              _bannerList = bannerModel.banners!;
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: black20BoldTextStyle,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: fixPadding * 2.0),
              children: [
                userProfile(),
                heightSpace,
                heightSpace,
                heightSpace,
                Container(
                    margin: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: new Duration(seconds: 3),
                          height: 150),
                      items: _bannerList
                          .map((item) => Container(
                                child: bannerItems(item),
                              ))
                          .toList(),
                    )),
                newMatchesList.isNotEmpty ? newMatches() : Container(),
                discoverMatches(),
                strimgurl.isEmpty && strgender.toLowerCase() != 'female'
                    ? completeProfile()
                    : Container(),
                membersLookingForYou(),
              ],
            ),
    );
  }

  Widget bannerItems(Banners? item) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          IntentUtils.OpenBrowser(item!.redirectUrl!);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            item!.bannerUrl!,
            width: double.infinity,
            height: width,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  emptyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const Icon(
                Icons.star_rounded,
                color: greyColor,
                size: 35,
              ),
              Text(
                'Match list is empty',
                textAlign: TextAlign.center,
                style: grey14SemiBoldTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  userProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          strimgurl.isNotEmpty
              ? InkWell(
                  onTap: checkPermission,
                  child: CircleAvatar(
                    // borderRadius: BorderRadius.circular(5),
                    radius: 50,
                    backgroundImage: NetworkImage(strimgurl),
                  ),
                )
              : InkWell(
                  onTap: checkPermission,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),
                ),
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
              heightSpace,
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                width: 160.0,
                lineHeight: 3.0,
                percent: 1,
                progressColor: primaryColor,
                backgroundColor: greyColor,
              ),
              heightSpace,
              // Text(
              //   '77% Profile Completion',
              //   style: grey13RegularTextStyle,
              // ),
              heightSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding,
                        vertical: 3,
                      ),
                      color: primaryColor,
                      child: Text(
                        strsubscriptionplan,
                        style: white13RegularTextStyle,
                      ),
                    ),
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
                                builder: (context) => SubscriptionPaln()),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: fixPadding,
                          vertical: 3,
                        ),
                        child: Text(
                          'Upgrade plan',
                          style: primaryColor13RegularTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  newMatches() {
    return Column(
      children: [
        title('New Matches'),
        SizedBox(
          height: height * 0.23,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: newMatchesList.length,
            itemBuilder: (context, index) {
              final item = newMatchesList[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ? fixPadding * 2.0 : fixPadding),
                child: InkWell(
                  onTap: () {
                    if (isSubscribtionActive) {
                      if (totalVisitCount == "Unlimited" ||
                          myVisitCount < int.parse(totalVisitCount) ||
                          strgender.toLowerCase() == 'female') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetails(
                              tag: newMatchesList.elementAt(index),
                              image: newMatchesList.elementAt(index).imageUrl,
                              id: newMatchesList.elementAt(index).id,
                            ),
                          ),
                        );
                      } else {
                        showSnackBar(context,
                            'Your daily profile visit limit has exceeded');
                      }
                    } else {
                      showSnackBar(
                          context, 'Upgrade plan to see profile details');
                    }
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: newMatchesList[index],
                                child: SizedBox(
                                  height: height * 0.1316,
                                  width: width * 0.36,
                                  child: item.imageUrl.toString().isNotEmpty
                                      ? Image.network(
                                          item.imageUrl as String,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/logo.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 5,
                                child: InkWell(
                                  onTap: () {
                                    // star profile
                                    item.isStared == false
                                        ? addToWishlist(item.id)
                                        : removeWishlist(item.id, item.name);

                                    setState(() {
                                      item.isStared = !(item.isStared as bool);
                                    });
                                  },
                                  child: Icon(
                                    item.isStared == true
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 25,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(fixPadding / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.toString().isNotEmpty
                                      ? item.name
                                      : 'Unknown',
                                  style: black14SemiBoldTextStyle,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${item.age} Yrs,',
                                      style: grey12RegularTextStyle,
                                    ),
                                    widthSpace,
                                    Text(
                                      item.userHeight as String,
                                      style: grey12RegularTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  item.city as String,
                                  style: grey12RegularTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  discoverMatches() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding * 2.0,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Matches',
            style: black16BoldTextStyle,
          ),
          heightSpace,
          heightSpace,
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    IntentUtils.fireIntentwithoutFinish(
                        context, DiscoverMatches(strcity, strproffession));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: fixPadding * 2.0),
                    padding:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: greyColor.withOpacity(0.15),
                          blurRadius: 2,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 40,
                          color: greyColor,
                        ),
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: black14SemiBoldTextStyle,
                            ),
                            Text(
                              '$strLocationMatch matches',
                              style: black13RegularTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    IntentUtils.fireIntentwithoutFinish(
                        context, DiscoverMatches(strcity, strproffession));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: greyColor.withOpacity(0.15),
                          blurRadius: 2,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.work_rounded,
                          size: 40,
                          color: greyColor,
                        ),
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profession',
                              style: black14SemiBoldTextStyle,
                            ),
                            Text(
                              '$strProfessionMatch matches',
                              style: black13RegularTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  completeProfile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding * 2.0,
        0,
      ),
      padding: const EdgeInsets.all(fixPadding),
      decoration: BoxDecoration(
        color: const Color(0xfff1f8e9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Complete your profile for\nmore responses',
                style: black14BoldTextStyle,
              ),
              const Icon(
                Icons.timelapse,
                color: primaryColor,
              ),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'The first thing that members\nlook for in a is a photo',
                style: black13RegularTextStyle,
              ),
              GestureDetector(
                onTap: checkPermission,
                child: Container(
                  margin: const EdgeInsets.only(top: fixPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.5,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Add Photo',
                    style: white14BoldTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  membersLookingForYou() {
    return Column(
      children: [
        title('${membersList.length} Members Looking For You'),
        SizedBox(
          height: height * 0.23,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: membersList.length,
            itemBuilder: (context, index) {
              final item = membersList[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ? fixPadding * 2.0 : fixPadding),
                child: InkWell(
                  onTap: () {
                    if (isSubscribtionActive) {
                      //check if visit count is exceeded
                      if (totalVisitCount == "Unlimited" ||
                          myVisitCount < int.parse(totalVisitCount) ||
                          strgender.toLowerCase() == 'female') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetails(
                              tag: membersList[index],
                              image: item.imageUrl,
                              id: item.id,
                            ),
                          ),
                        );
                      } else {
                        showSnackBar(context,
                            'Your daily profile visit limit has exceeded');
                      }
                    } else {
                      showSnackBar(
                          context, 'Upgrade plan to see profile details');
                    }
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: membersList[index],
                                child: SizedBox(
                                  height: height * 0.1316,
                                  width: width * 0.36,
                                  child: item.imageUrl != null
                                      ? Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/logo.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              // Positioned(
                              //   bottom: 2,
                              //   right: 5,
                              //   child: InkWell(
                              //     onTap: () {
                              //       item.isStared == false
                              //           ?  addToWishlist(item.id) : removeWishlist(item.id,item.name);
                              //
                              //       setState(() {
                              //         item.isStared = !(item.isStared as bool);
                              //       });
                              //     },
                              //     child: Icon(
                              //       // item['star']! == true
                              //       //     ? Icons.star_rounded
                              //       //     :
                              //       Icons.star_border_rounded,
                              //       size: 18,
                              //       color: primaryColor,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(fixPadding / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.toString().isNotEmpty
                                      ? item.name
                                      : 'Unknown',
                                  style: black14SemiBoldTextStyle,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${item.age} Yrs,',
                                      style: grey12RegularTextStyle,
                                    ),
                                    widthSpace,
                                    Text(
                                      item.userHeight as String,
                                      style: grey12RegularTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  item.city as String,
                                  style: grey12RegularTextStyle,
                                )
                                // Row(
                                //   children: [
                                //     Text(
                                //       '#${item.id}',
                                //       style: grey12RegularTextStyle,
                                //     ),
                                //     widthSpace,
                                //     Text(
                                //       item.city as String,
                                //       style: grey12RegularTextStyle,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  title(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding * 2.0,
        fixPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: black16BoldTextStyle,
          ),
          // Text(
          //   'See all',
          //   style: primaryColor12BlackTextStyle,
          // ),
        ],
      ),
    );
  }

  Dialog profileWarningDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              fixPadding * 2.0,
              fixPadding * 2.0,
              fixPadding * 2.0,
              fixPadding * 2.0,
            ),
            padding: const EdgeInsets.all(fixPadding),
            decoration: BoxDecoration(
              color: const Color(0xfff1f8e9),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Complete your profile for\nmore responses',
                        style: black14BoldTextStyle,
                      ),
                    ),
                    const Icon(
                      Icons.timelapse,
                      color: primaryColor,
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Text(
                  getDialogText(),
                  style: black13RegularTextStyle,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: fixPadding),
                    padding: const EdgeInsets.symmetric(
                      horizontal: fixPadding * 2.5,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Update',
                      style: white14BoldTextStyle,
                    ),
                  ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(
                //       child: Text(
                //         'Update your profile to help\nus finding best matches for you',
                //         style: black13RegularTextStyle,
                //       ),
                //       flex: 7,
                //     ),
                //     Flexible(
                //       flex: 3,
                //       child: GestureDetector(
                //         onTap: () {
                //             Navigator.of(context).pop(true);
                //         },
                //         child: Container(
                //           margin: const EdgeInsets.only(top: fixPadding),
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: fixPadding * 0.5,
                //             vertical: 8,
                //           ),
                //           decoration: BoxDecoration(
                //             color: primaryColor,
                //             borderRadius: BorderRadius.circular(5),
                //           ),
                //           child: Text(
                //             'Update',
                //             style: white14BoldTextStyle,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  checkPermission() async {
    final status = await Permission.storage.request();
    // final status2 = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted.');
      _pickImage();
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
      await Permission.storage.shouldShowRequestRationale;
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      final file = Io.File(pickedFile!.path);

      final sample = await ImageCrop.sampleImage(
        file: file,
        preferredSize: context.size!.longestSide.ceil(),
      );

      _sample?.delete();
      _file?.delete();

      setState(() {
        _imageFile = pickedFile;

        _sample = sample;
        _file = file;
        //
        // final bytes = Io.File(_imageFile.path).readAsBytesSync();
        // Uri uri = Uri.file(_imageFile.path);
        // String strextension = uri.pathSegments.last.split(".").last;
        //
        // String imagename = strname.toLowerCase().replaceAll(" ", "")+id+"_prImg.$strextension";
        //
        // String img64 = base64Encode(bytes);
        //
        // print('strusrimage: '+imagename);
        //
        // //update image
        // updateImage(img64,imagename);
      });
      _cropImage();
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  Future<void> _cropImage() async {
    Map results = await Navigator.of(context).push(MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new CropImgScreen(sample: _sample, file: _file);
      },
    ));

    if (results != null && results.containsKey('img64')) {
      setState(() {
        _lastCropped = results['_lastCropped'];
      });

      String strextension = results['strextension'];

      String imagename = strname.toLowerCase().replaceAll(" ", "") +
          id +
          "_prImg.$strextension";

      updateImage(results['img64'], imagename);
    }
  }

  Future<void> updateImage(String img64, String imagename) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel =
              await API_Manager.updateProfilePicture(img64, imagename, id);

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
              _sample = null;
            });

            imageCache.clear();
            showSnackBar(context, resultModel.message);
            fetchDetails();
            fetchMembers();
          } else {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, resultModel.message);
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

  Future<void> addToWishlist(String wishId) async {
    try {
      final ResultModel resultModel =
          await API_Manager.insertUsersWishlist(id, wishId);

      setState(() {
        _isLoading = true;
      });
      if (resultModel.error != true) {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(context, resultModel.message);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, resultModel.message);
      }
    } on Exception catch (_, e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }
  }

  Future<void> removeWishlist(String wishId, name) async {
    try {
      final ResultModel resultModel =
          await API_Manager.removeWishlistUser(id, wishId);

      setState(() {
        _isLoading = true;
      });
      if (resultModel.error != true) {
        setState(() {
          _isLoading = false;
        });

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool("isLoggedIn", true);
        // prefs.setString(Prefs.PHONE, strphone);

        showSnackBar(context, resultModel.message);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, '$name remove from shortlist');
      }
    } on Exception catch (_, e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }
  }

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String getDialogText() {
    if (strname.isEmpty) {
      return 'Add your name to profile';
    } else if (strReligion == "Not Specified") {
      return 'Update your profile with adding your religion for\nmore responses';
    } else if (strAge.isEmpty) {
      return 'Add your age to profile to find perfect match';
    } else if (strproffession.isEmpty) {
      return 'Add your profession to profile for more responses';
    } else {
      return 'Complete your profile for more responses';
    }
  }
}

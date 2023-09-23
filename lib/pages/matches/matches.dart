import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/widget/column_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';
import '../../models/users_match_model.dart';

class Matches extends StatefulWidget {
  const Matches({Key? key}) : super(key: key);

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  late double height;
  String id="",strgender="Male",strMyName="";
  bool _isLoading =  false;
  List<UsersMatch> newMatchesList = <UsersMatch>[];
  final String NOTIFICATION_TITLE = "New Request";
  final String NOTIFICATION_MSG = " has send you an interest!";
  final String NOTIFICATION_TYPE = "";
  String totalVisitCount="";
  int myVisitCount=0;

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
    String? sgender = prefs.getString(Prefs.USER_GENDER);
    String? date = prefs.getString(Prefs.PROFILE_VISIT_DATE);
    String? visitCount = prefs.getString(Prefs.PROFILE_VISIT_COUNT);
    String? pvisitCount = prefs.getString(Prefs.PLAN_VISIT_COUNT);

    print(sid);
    setState(() {
      id = sid!;
      strgender = sgender!;
      totalVisitCount = pvisitCount !=null ? pvisitCount : "0" ;
      print(totalVisitCount);

      if(date!=null)
      {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        String strCurrentDate = formatter.format(DateTime.now());

        if(formatter.parse(strCurrentDate)==formatter.parse(strCurrentDate))
        {
          visitCount = visitCount != null ? visitCount : "0";
          myVisitCount = int.parse(visitCount!);
        }
        else{
          myVisitCount = 0;
        }
      }

    });

    fetchMatches();
    logdedInUserDetails();

  }

  Future<void> logdedInUserDetails() async {
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

              strMyName = userProfile.name;
              // strimgurl = userProfile.imageUrl;
              // strAge = userProfile.age;
              // strReligion = userProfile.religion;
              // strgender = userProfile.gender.isNotEmpty ? userProfile.gender  : "Male";
              // strcity = userProfile.city;
              // strproffession = userProfile.occupation;

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
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Matches',
          style: black20BoldTextStyle,
        ),
        // actions: [
        //   InkWell(
        //     onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const MatchesSort()),
        //     ),
        //     child: Image.asset(
        //       'assets/icons/filter.png',
        //       height: 20,
        //       width: 20,
        //     ),
        //   ),
        //   widthSpace,
        //   widthSpace,
        //   widthSpace,
        //   widthSpace,
        // ],
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ) : ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: fixPadding * 2.0,
              top: fixPadding * 2.0,
            ),
            child: Text(
              newMatchesList.length.toString()+' Matches based on your preferences',
              style: grey13RegularTextStyle,
            ),
          ),
          matches(),
        ],
      ),
    );
  }

  matches() {

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.4;
    final double itemWidth = size.width / 2;

    return newMatchesList.length > 0 ? Container(
      margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 5.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: newMatchesList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = newMatchesList[index];
          return InkWell(
            onTap: () {

              if (totalVisitCount == "Unlimited" || myVisitCount < int.parse(totalVisitCount)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetails(
                      tag: newMatchesList[index],
                      image: item.imageUrl as String?,
                      id: item.id as String?,
                    ),
                  ),
                );
              }
              else {
                showSnackBar(context,
                    'Your daily profile visit limit has exceeded');
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
                  children: [
                    Hero(
                      tag: newMatchesList[index],
                      child: SizedBox(
                        height: height * 0.20,
                        width: double.infinity,
                        child: item.imageUrl.toString().isNotEmpty ? Image.network(
                          item.imageUrl as String,
                          fit: BoxFit.fill,
                        ) : Image.asset('assets/logo.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(fixPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 8,
                                child: item.name.toString().isNotEmpty ?
                                Text(
                                  '${item.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: black17BoldTextStyle,
                                ) : Text(
                                  'Unknown',
                                  style: black17BoldTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {

                                    item.isStared == false
                                        ?  addToWishlist(item.id) : removeWishlist(item.id,item.name);

                                    setState(() {
                                      item.isStared = !(item.isStared as bool);
                                    });

                                  },
                                  child: Icon(
                                    item.isStared == true
                                        ? Icons.favorite_rounded :
                                    Icons.favorite_outline_rounded,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   item.education as String,
                          //   style: grey13RegularTextStyle,
                          // ),
                          heightSpace,
                          Text(
                            '${item.age} Yrs, ${item.userHeight}',
                            style: black13SemiBoldTextStyle,
                          ),
                          Text(
                            '${item.cast}, ${item.city} - ${item.state}',
                            style: grey12castTextStyle,
                          ),
                          heightSpace,
                          heightSpace,
                          !item.interestApproved ? Center(
                            child: InkWell(
                              onTap: (){
                                if(!item.isInterestAdded) {
                                  sendInterest(item.id,item.name);
                                }
                              },
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                    vertical: fixPadding / 2),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  item.isInterestAdded ? 'Requested' : 'Send Interest',
                                  style: primaryColor15BoldTextStyle,
                                ),
                              ),
                            ),
                          )
                              : Container(),
                          // !item.interestApproved ? heightSpace : Container(),
                          // !item.interestApproved ? heightSpace : Container(),
                          // Center(
                          //   child: InkWell(
                          //     onTap: () {
                          //       if(item.interestApproved) {
                          //         if (totalVisitCount == "Unlimited" ||
                          //             totalVisitCount != "0") {
                          //           IntentUtils.makePhoneCall(
                          //               context, item.mobile);
                          //         }
                          //       }
                          //       else{
                          //         showSnackBar(context, 'You will be able to call person once the interest is approved');
                          //       }
                          //     } ,
                          //     child: Container(
                          //       width: 120,
                          //       padding: const EdgeInsets.symmetric(
                          //           vertical: fixPadding / 2),
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           color: primaryColor,
                          //           width: 1.5,
                          //         ),
                          //         borderRadius: BorderRadius.circular(5),
                          //       ),
                          //       child: Text(
                          //         'Call Now',
                          //         style: primaryColor15BoldTextStyle,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          heightSpace,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     InkWell(
                          //       onTap: () => Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => MatchResult(
                          //             image: item.imageUrl as String?,
                          //           ),
                          //         ),
                          //       ),
                          //       child: Text(
                          //         'View Matching Results',
                          //         style: primaryColor11BlackTextStyle,
                          //       ),
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
          );
        },
      ),
    )
    : Container();
  }

  Future<void> fetchMatches() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final UserMatchModel matchModel = await API_Manager.fetchUsersMatch(strgender,id);


          if (matchModel.error!=true) {

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

  Future<void> sendNotification(String reqId) async {

   String msg = strMyName + NOTIFICATION_MSG;
    try {
      final ResultModel resultModel = await API_Manager.sendUserSinglePush(NOTIFICATION_TITLE,msg,NOTIFICATION_TYPE,reqId);

      setState(() {
        _isLoading = true;
      });
      if (resultModel.error != true) {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(context,resultModel.message);

        // Navigator.of(context).pop();
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);

      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

  }

  Future<void> sendInterest(String reqId,String name) async {

    try {
      final ResultModel resultModel = await API_Manager.insertUserRequest(id,reqId);

      setState(() {
        _isLoading = true;
      });
      if (resultModel.error != true) {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(context,resultModel.message);

        sendNotification(reqId);
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);

      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

  }

  Future<void> addToWishlist(String wishId) async {

    try {
      final ResultModel resultModel = await API_Manager.insertUsersWishlist(id,wishId);

      setState(() {
        _isLoading = true;
      });
      if (resultModel.error != true) {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(context,resultModel.message);

        // Navigator.of(context).pop();
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);

      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

  }

  Future<void> removeWishlist(String wishId, name) async {

    try {
      final ResultModel resultModel = await API_Manager.removeWishlistUser(id,wishId);

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

        showSnackBar(context,'$name remove from shortlist');
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);

      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

  }
}

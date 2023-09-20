import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/models/received_req_model.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String isSelected = 'accepted',strMyName = "";
  bool _isLoading = false;
  String id = "",totalVisitCount="";
  int myVisitCount = 0;
  final String NOTIFICATION_TITLE = "New Request";
  final String NOTIFICATION_MSG = " has accepted your interest!";
  final String NOTIFICATION_TYPE = "";

  List<ReceivedRequest> userList = <ReceivedRequest>[];

  List<ReceivedRequest> requestList = <ReceivedRequest>[];

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
      totalVisitCount = pvisitCount !=null ? pvisitCount : "0" ;

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

    logdedInUserDetails();
    fetchRequests();
    fetchAcceptedRequests();

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(
          'Chats',
          style: black20BoldTextStyle,
        ),
      ),
      body:  _isLoading ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              fixPadding * 2.0,
              fixPadding * 2.0,
              fixPadding * 2.0,
              fixPadding * 2.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = 'accepted';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: fixPadding / 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected == 'accepted'
                                ? primaryColor
                                : greyColor,
                            width: 3.5,
                          ),
                        ),
                      ),
                      child: Text(
                        'Accepted',
                        style: TextStyle(
                          color: isSelected == 'accepted'
                              ? primaryColor
                              : greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = 'new';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: fixPadding / 3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isSelected == 'new' ? primaryColor : greyColor,
                            width: 3.5,
                          ),
                        ),
                      ),
                      child: Text(
                        'New Request',
                        style: TextStyle(
                          color: isSelected == 'new' ? primaryColor : greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isSelected == 'accepted'
              ? userList.isNotEmpty ? buildChats() : userListEmpty()
              : requestList.isEmpty
                  ? requestListEmpty()
                  : request(),
        ],
      ),
    );
  }

  acceptedReq() {
    if(userList.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final item = userList[index];
            return InkWell(
              onTap: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Chat(item.userId, item.imageUrl, item.name)),
                  ),
              child: Padding(
                padding: (index == 0)
                    ? const EdgeInsets.fromLTRB(
                  fixPadding * 2.0,
                  0,
                  fixPadding * 2.0,
                  fixPadding,
                )
                    : const EdgeInsets.fromLTRB(
                  fixPadding * 2.0,
                  fixPadding,
                  fixPadding * 2.0,
                  fixPadding,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: getImageWidget(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    widthSpace,
                    widthSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name.toString().isNotEmpty ? item.name : 'Unknown',
                            style: black13SemiBoldTextStyle,
                          ),
                          Text(
                            'Type a message',
                            style: grey12RegularTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "00:00",
                          style: grey9RegularTextStyle,
                        ),
                        // item['msgCount'] == 0
                        //     ?
                        Container()
                        // : Container(
                        //     padding: const EdgeInsets.all(3),
                        //     decoration: const BoxDecoration(
                        //       color: primaryColor,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Text(
                        //       item['msgCount'].toString(),
                        //       style: white9BlackTextStyle,
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    else{
      return userListEmpty();
    }
  }

  chat(int index,ReceivedRequest item, doc) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chat(item.userId,item.imageUrl,item.name)),
      ),
      child: Padding(
        padding: (index == 0)
            ? const EdgeInsets.fromLTRB(
          fixPadding * 2.0,
          0,
          fixPadding * 2.0,
          fixPadding,
        )
            : const EdgeInsets.fromLTRB(
          fixPadding * 2.0,
          fixPadding,
          fixPadding * 2.0,
          fixPadding,
        ),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: getImageWidget(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            widthSpace,
            widthSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toString().isNotEmpty ? item.name : 'Unknown',
                    style: black13SemiBoldTextStyle,
                  ),
                  Text(
                    doc['content'],
                    style: grey12RegularTextStyle,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  doc['timestamp'],
                  style: grey9RegularTextStyle,
                ),
                // item['msgCount'] == 0
                //     ?
                Container()
                // : Container(
                //     padding: const EdgeInsets.all(3),
                //     decoration: const BoxDecoration(
                //       color: primaryColor,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Text(
                //       item['msgCount'].toString(),
                //       style: white9BlackTextStyle,
                //     ),
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget buildChats() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('lastMessage.timestamp', descending: true)
            .where('users', arrayContains: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  chat(index, getUser(snapshot.data?.docs[index]['lastMessage']['idFrom'],snapshot.data?.docs[index]['lastMessage']['idTo']),
                      snapshot.data?.docs[index]['lastMessage']),
              itemCount: snapshot.data?.docs.length,
              reverse: false,
            );
          } else {
            return acceptedReq();
          }
        },
      ),
    );
  }

  ReceivedRequest getUser(String usrId, String peerId)
  {
    for(int i=0; i<userList.length; i++)
    {
      if(usrId == userList.elementAt(i).userId || peerId == userList.elementAt(i).userId)
      {
        return userList.elementAt(i);
      }
    }
    return userList.elementAt(0);
  }

  request() {
    return requestList.length > 0 ? Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: requestList.length,
        itemBuilder: (context, index) {
          final item = requestList[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              fixPadding * 2.0,
              0,
              fixPadding * 2.0,
              fixPadding * 3.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: getImageWidget(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    widthSpace,
                    widthSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.name,
                                style: black14SemiBoldTextStyle,
                              ),
                              const Spacer(),
                              Text(
                                '${item.age} yrs - ${item.userHeight}',
                                style: grey12SemiBoldTextStyle,
                              ),
                              widthSpace,
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    requestList.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 15,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.cast+","+item.religion,
                            style: grey13RegularTextStyle,
                          ),
                          Text(
                            '${item.city}, ${item.state}',
                            style: grey13RegularTextStyle,
                          ),
                          Text(
                            '${item.occupation} / ${item.education}',
                            style: grey13RegularTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {

                        if (totalVisitCount == "Unlimited" || myVisitCount < int.parse(totalVisitCount)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileDetails(
                                tag: requestList[index],
                                image: item.imageUrl,
                              ),
                            ),
                          );
                        }
                        else {
                          showSnackBar(context,
                              'Your daily profile visit limit has exceeded');
                        }
                        } ,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'More Info',
                            style: primaryColor15BoldTextStyle,
                          ),
                        ),
                      ),
                    ),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          requestList.removeAt(index);
                          approveInterest(item.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Accept Request',
                            style: white15BoldTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ) : Container();
  }

  requestListEmpty() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'No new request',
            style: grey14SemiBoldTextStyle,
          )
        ],
      ),
    );
  }

  userListEmpty() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'No chats',
            style: grey14SemiBoldTextStyle,
          )
        ],
      ),
    );
  }



  Future<void> fetchRequests() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final RecievedRequestModel recievedRequestModel = await API_Manager.fetchUserReceivedRequest(id);


          if (recievedRequestModel.error!=true) {


            setState(() {
              _isLoading = false;
              requestList = recievedRequestModel.receivedRequest;
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


  Future<void> fetchAcceptedRequests() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final RecievedRequestModel recievedRequestModel = await API_Manager.fetchUserAcceptedRequest(id);


          if (recievedRequestModel.error!=true) {


            setState(() {
              _isLoading = false;
              userList = recievedRequestModel.receivedRequest;
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

  Future<void> approveInterest(String reqId) async {

    try {
      final ResultModel resultModel = await API_Manager.acceptUserRequest(reqId);

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

        showSnackBar(context,resultModel.message);
        sendNotification(reqId);

      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);

        Navigator.of(context).pop();
      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

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

        fetchRequests();
        fetchAcceptedRequests();
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,resultModel.message);
        fetchRequests();
        fetchAcceptedRequests();
      }
    }
    on Exception catch (_, e){
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }

  }

  getImageWidget(imageUrl) {
    return imageUrl.toString().isNotEmpty ? NetworkImage(imageUrl) : AssetImage('assets/logo.jpg');
  }
}

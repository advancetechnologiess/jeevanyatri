import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../constants/prefs.dart';

class Chat extends StatefulWidget {
  String peerId="",peerProfile="",peerName="";

  Chat(String id,String imageUrl,String name, {Key? key}) : super(key: key)
  {
    peerId = id;
    peerProfile = imageUrl;
    peerName = name;
  }

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();
  String? _currentMessage;
  DateTime time = DateTime.now();
  String convoId="",id="",myProfile="";
  String totalVisitCount="";
  int myVisitCount=0;

  List messageList = [];

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
    String? sprofile = prefs.getString(Prefs.USER_PROFILE);
    String? date = prefs.getString(Prefs.PROFILE_VISIT_DATE);
    String? visitCount = prefs.getString(Prefs.PROFILE_VISIT_COUNT);
    String? pvisitCount = prefs.getString(Prefs.PLAN_VISIT_COUNT);

    print(sid);
    setState(() {
      id = sid!;
      myProfile = sprofile!;
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

    getConversationID(id, widget.peerId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.peerName.isNotEmpty ? widget.peerName : 'Unknown',
              style: black20BoldTextStyle,
            ),
            Text(
              'Online',
              style: grey12RegularTextStyle,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          buildMessages(),
          textField(),
        ],
      ),
    );
  }

  getConversationID(String userID, String peerID) {
    String cId =  userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;

    setState(() {
      convoId = cId;
    });
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(convoId)
            .collection(convoId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            messageList = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data?.docs[index]),
              itemCount: snapshot.data?.docs.length,
              reverse: true,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildItem(int index, QueryDocumentSnapshot? document) {
    if (!document!['read'] && document['idTo'] == id) {
      // Database.updateMessageRead(document, convoID);
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoId)
          .collection(convoId)
          .doc(document.id);

      documentReference.set(<String, dynamic>{'read': true}, SetOptions(merge: true));
    }
    bool m =
    (index == 0 || document['timestamp'] != messageList[index - 1]['timestamp'])
        ? true
        : false;
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 230),
            margin: EdgeInsets.only(
              bottom: fixPadding * 2.0,
              right: m ? 0 : fixPadding * 4.8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 1.3,
              vertical: fixPadding,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  document['content'] as String,
                  overflow: TextOverflow.fade,
                  style: white12RegularTextStyle,
                ),
              ],
            ),
          ),
          m
              ? Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: fixPadding),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: getImageWidget(myProfile),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          )
              : Container(),
        ],
      );
    } else {
      // Left (peer message)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          m
              ? Stack(
            children: [
              Container(
                margin:
                const EdgeInsets.only(right: fixPadding),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: getImageWidget(widget.peerProfile),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 8,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          )
              : Container(),
          Container(
            constraints: const BoxConstraints(maxWidth: 230),
            margin: EdgeInsets.only(
              bottom: fixPadding * 2.0,
              left: m ? 0 : fixPadding * 4.8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 1.3,
              vertical: fixPadding,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: greyColor.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  document['content'] as String,
                  overflow: TextOverflow.fade,
                  style: grey12RegularTextStyle,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  getImageWidget(imageUrl) {
    return imageUrl!=null ? NetworkImage(imageUrl) : AssetImage('assets/logo.jpg');
  }


  writeMessage(String content){
    var uuid = Uuid();
    // FirebaseStorage.instance.ref('messages').child(convoId).getData();
    String timestamp = DateTime.now().toString();
    final DocumentReference convoDoc =
    FirebaseFirestore.instance.collection('messages').doc(convoId);

  //   var userChat = <String, dynamic>{
  //   'idFrom': id,
  //   'idTo': widget.peerId,
  //   'timestamp': timestamp,
  //   'content': content,
  //   'read': false
  // };
  //
  //   convoDoc.collection(convoId).add(userChat).then((dynamic success) {
  //
  //   });

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': widget.peerId,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, widget.peerId]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoId)
          .collection(convoId)
          .doc(timestamp);

      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
        await transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  messages() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          final item = messageList[index];
          bool m =
              (index == 0 || item['time'] != messageList[index - 1]['time'])
                  ? true
                  : false;
          return item['isMe']! == true
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 230),
                      margin: EdgeInsets.only(
                        bottom: fixPadding * 2.0,
                        right: m ? 0 : fixPadding * 4.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 1.3,
                        vertical: fixPadding,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            item['message'] as String,
                            overflow: TextOverflow.fade,
                            style: white12RegularTextStyle,
                          ),
                        ],
                      ),
                    ),
                    m
                        ? Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: fixPadding),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(item['image'] as String),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 8,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    m
                        ? Stack(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: fixPadding),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(item['image'] as String),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 230),
                      margin: EdgeInsets.only(
                        bottom: fixPadding * 2.0,
                        left: m ? 0 : fixPadding * 4.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: fixPadding * 1.3,
                        vertical: fixPadding,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: greyColor.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            item['message'] as String,
                            overflow: TextOverflow.fade,
                            style: grey12RegularTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  textField() {
    final message = {
      'image': 'assets/users/user1.png',
      'message': _currentMessage,
      'time': time.toString(),
      'isMe': true,
    };
    return Container(
      height: 45,
      padding: const EdgeInsets.all(fixPadding),
      color: whiteColor,
      alignment: Alignment.center,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _currentMessage = value;
          });
        },
        controller: messageController,
        cursorColor: primaryColor,
        style: black14SemiBoldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 2),
          hintText: 'Type your message',
          hintStyle: grey12RegularTextStyle,
          prefixIcon: const Icon(
            Icons.emoji_emotions_outlined,
            color: greyColor,
            size: 15,
          ),
          suffixIcon: InkWell(
            onTap: () {
              writeMessage(messageController.text);
              messageController.clear();
            },
            child: const Icon(
              Icons.send_rounded,
              size: 30,
              color: primaryColor,
            ),
          ),
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  messageActions(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.attach_file,
          size: 13,
          color: greyColor,
        ),
        widthSpace,
        widthSpace,
        const Icon(
          Icons.photo_camera,
          size: 13,
          color: greyColor,
        ),
        widthSpace,
        widthSpace,
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: whiteColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.15),
                blurRadius: 2,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.mic,
            size: 11,
            color: greyColor,
          ),
        ),
        widthSpace,
        widthSpace,
        InkWell(
          onTap: () {
            writeMessage(messageController.text);
            messageController.clear();
          },
          child: const Icon(
            Icons.send_rounded,
            size: 13,
            color: greyColor,
          ),
        ),
        widthSpace,
        widthSpace,
        widthSpace,
        widthSpace,
      ],
    );
  }
}

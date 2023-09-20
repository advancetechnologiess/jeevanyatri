import 'package:intl/intl.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/result_model.dart';
import '../../models/shortlist_model.dart';

class Shortlist extends StatefulWidget {
  const Shortlist({Key? key}) : super(key: key);

  @override
  _ShortlistState createState() => _ShortlistState();
}

class _ShortlistState extends State<Shortlist> {
  List<ShortlistUsers> shortList = <ShortlistUsers>[];
  bool _isLoading = false;
  String id = "" ,totalVisitCount="";
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
    String? date = prefs.getString(Prefs.PROFILE_VISIT_DATE);
    String? visitCount = prefs.getString(Prefs.PROFILE_VISIT_COUNT);
    String? pvisitCount = prefs.getString(Prefs.PLAN_VISIT_COUNT);

    print(sid);
    setState(() {
      id = sid!;
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

    fetchShortlistUsers();

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
          'Shortlisted',
          style: black20BoldTextStyle,
        ),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ) : shortList.isEmpty ? emptyList() : shortLists(),
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
                'Short list is empty',
                textAlign: TextAlign.center,
                style: grey14SemiBoldTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  getImageWidget(imageUrl) {
    return imageUrl!=null ? NetworkImage(imageUrl) : AssetImage('assets/logo.jpg');
  }

  shortLists() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: shortList.length,
      itemBuilder: (context, index) {
        final item = shortList[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(
            fixPadding * 2.0,
            index == 0 ? fixPadding * 2.0 : 0,
            fixPadding * 2.0,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                      if (totalVisitCount == "Unlimited" || myVisitCount < int.parse(totalVisitCount)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileDetails(
                              tag: shortList[index],
                              image: item.imageUrl,
                            ),
                          ),
                        );
                      }else {
                        showSnackBar(context,
                            'Your daily profile visit limit has exceeded');
                      }
                    },
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
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
                            style: black14SemiBoldTextStyle,
                          ),
                          Text(
                            '${item.occupation}   ${item.age} yrs, ${item.userHeight}',
                            style: grey12RegularTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.religion}, ${item.city} - ${item.state}',
                                style: grey12RegularTextStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  removeWishlist(item.id,item.name);
                                  setState(() {
                                    shortList.removeAt(index);
                                  });
                                },
                                child: Text(
                                  'Remove',
                                  style: primaryColor12BlackTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              divider(),
            ],
          ),
        );
      },
    );
  }

  divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: fixPadding * 2.0),
      color: greyColor,
      height: 1,
      width: double.infinity,
    );
  }

  Future<void> fetchShortlistUsers() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final ShortlistModel shortlistModel = await API_Manager.fetchShortlistedUsers(id);


          if (shortlistModel.error!=true) {


            setState(() {
              _isLoading = false;
              shortList = shortlistModel.shortlist;
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

  Future<void> removeWishlist(String wishId, String name) async {

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

        Navigator.of(context).pop();
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
}

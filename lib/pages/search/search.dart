import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/widget/column_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/users_match_model.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>{

  List<UsersMatch> newSearchList = <UsersMatch>[];
  String aget="40",agef="18",relg="Any",caste="",city="",mstatus="",strgender="",id="",income="";
  bool _isLoading =  false;
  String totalVisitCount="";
  int myVisitCount=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    income = incomeArray.first;
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

    fetchFilteredList();

  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchFilter()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    setState((){
      var fieldsData = json.decode(result);
      relg = fieldsData['religion'];
      agef = fieldsData['ageFrom'];
      aget = fieldsData['ageTo'];
      mstatus = fieldsData['status'];
      caste = fieldsData['caste'] == 'Any' ? "" : fieldsData['caste'];
      city = fieldsData['city'] == 'Any' ? "" : fieldsData['city'];
      income = fieldsData['income'];
    });
    print("Values "+aget+" "+agef+" "+relg+" "+mstatus);
    fetchFilteredList();
  }

  Future<void> fetchFilteredList() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {

          setState(() {
            _isLoading = true;
          });

          final UserMatchModel matchModel = await API_Manager.filterUsers(strgender,agef,aget,mstatus,relg,caste,city,income);


          if (matchModel.error!=true) {

            setState(() {
              _isLoading = false;
            });


            setState(() {
              newSearchList = matchModel.usersMatch;
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
        automaticallyImplyLeading: false,
        title: Text(
          'Search',
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
          searchTextField(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          searches(),
          newSearchList.isNotEmpty
              ? InkWell(
                  onTap: () {
                    setState(() {
                      newSearchList.clear();
                    });
                  },
                  child: Text(
                    'Clear',
                    textAlign: TextAlign.center,
                    style: grey12BlackTextStyle,
                  ),
                )
              : Column(
                  children: [
                    const Icon(
                      Icons.search,
                      color: greyColor,
                      size: 30,
                    ),
                    Text(
                      'Search history is empty',
                      textAlign: TextAlign.center,
                      style: grey13SemiBoldTextStyle,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  searchTextField() {
    return SizedBox(
      height: 38,
      child: TextField(
        cursorColor: primaryColor,
        style: black14SemiBoldTextStyle,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search profile based on your preferences',
          hintStyle: grey11RegularTextStyle,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _navigateAndDisplaySelection(context),
                child: Image.asset(
                  'assets/icons/filter.png',
                  height: 16,
                  width: 16,
                  color: greyColor,
                ),
              ),
              widthSpace,
              widthSpace,
              const Icon(
                Icons.search,
                color: greyColor,
                size: 18,
              ),
            ],
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: greyColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: greyColor),
          ),
        ),
      ),
    );
  }

  searches() {
    return ColumnBuilder(
      itemCount: newSearchList.length,
      itemBuilder: (context, index) {
        final item = newSearchList[index];
        return Column(
          children: [
            InkWell(
              onTap: ()
                {
                  if (totalVisitCount == "Unlimited" || myVisitCount < int.parse(totalVisitCount)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetails(
                            tag: newSearchList[index],
                            image: item.imageUrl,
                          ),
                        ),
                      );
                    }
                    else {
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
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                        image: getImageWidget(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widthSpace,
                  widthSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: black14SemiBoldTextStyle,
                      ),
                      Text(
                        '${item.age} yrs - ${item.userHeight}',
                        style: grey12RegularTextStyle,
                      ),
                      Text(
                        '${item.city}, ${item.state}',
                        style: grey12RegularTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            divider(),
          ],
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

  getImageWidget(UsersMatch item) {
    return item.imageUrl.toString().isNotEmpty ? NetworkImage(item.imageUrl) :
    AssetImage('assets/logo.jpg');
  }
}

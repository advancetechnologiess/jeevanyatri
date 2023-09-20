import 'package:csc_picker/csc_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_me/models/family_details_model.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:meet_me/pages/userProfileDetail/edit_hobbies_dialog.dart';
import 'package:meet_me/pages/userProfileDetail/edit_languages_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/preference_model.dart';
import '../../models/profile_model.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:io' as Io;

import '../../models/result_model.dart';
import '../crop_image_screen.dart';
import 'edit_family_dialog.dart';
import 'edit_habits_dialog.dart';

class UserProfileDetail extends StatefulWidget {
  const UserProfileDetail({Key? key}) : super(key: key);

  @override
  _UserProfileDetailState createState() => _UserProfileDetailState();
}

class _UserProfileDetailState extends State<UserProfileDetail>
    with WidgetsBindingObserver {
  String isSelected = 'details';
  String strname = "User",
      strhobbies = "",
      strdrinking = "",
      streating = "",
      strsmoking = "",
      strlanguage = "";
  String? id,
      strage = "",
      strgender = "",
      strstatus = "",
      strcast = "",
      strheight = "",
      strweight = "",
      strdob = "";
  String strfstatus = "",
      strfvalues = "",
      strftype = "",
      strfincome = "",
      strfatherOccupation = "",
      strmotherOccupation = "",
      strbrother = "",
      strsister = "",
      strofwhichmarried = "",
      country = "",
      city = "",
      state = "",
      selectedCountry = "",
      selectedState = "",
      selectedCity = "";
  String strAgeFrom = "",
      strAgeTo = "",
      strHeightFrom = "",
      strHeightTo = "",
      strPrefEdu = "",
      strPrefCast = "",
      strPrefLoc = "",
      strimgurl = "",
      strbio = "",
      strprefincome = "",
      streducation = "",
      stroccupation = "",
      strcity = "",
      strstate = "",
      strmothertounge = "",
      strpincode = "",
      strreligion = '';
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  List<Hobby> _hobbyList = <Hobby>[];
  List<Language> _languageList = <Language>[];

  List<Family> _familyList = <Family>[];
  final cropKey = GlobalKey<CropState>();
  Io.File? _file;
  Io.File? _sample;
  Io.File? _lastCropped;
  double _editIconSize = 20.0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
    print("state : " + state.name);
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      fetchDetails();
      fetchPrefDetails();
    }
  }

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID);

    print(sid);
    setState(() {
      id = sid;
    });

    fetchDetails();
    fetchPrefDetails();
    fetchFamilyDetails();
  }

  Future<void> fetchFamilyDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final FamilyDetailsModel familyDetailsModel =
              await API_Manager.FetchUserFamilyDetails(id!);

          if (familyDetailsModel.error != true) {
            FamilyDetails familyDetails =
                familyDetailsModel.familyDetails.first;

            setState(() {
              strfstatus = familyDetails.family_status;
              strfvalues = familyDetails.family_vlaues;
              strftype = familyDetails.family_type;
              strfincome = familyDetails.family_income;
              strfatherOccupation = familyDetails.father_occupation;
              strmotherOccupation = familyDetails.mother_occupation;
              strbrother = familyDetails.brothers;
              strofwhichmarried = familyDetails.ofWhich_married;
              strsister = familyDetails.sisters;
              country = familyDetails.country;
              state = familyDetails.state;
              city = familyDetails.city;
            });

            debugPrint('city $city');
            debugPrint('state $state');
            setState(() {
              _isLoading = false;
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

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ProfileModel profileModel =
              await API_Manager.FetchUserProfile(id!);

          if (profileModel.error != true) {
            UserProfile userProfile = profileModel.userProfile.first;

            setState(() {
              _isLoading = false;
              strimgurl = userProfile.imageUrl;
              strname = userProfile.name;
              strage = userProfile.age.isNotEmpty
                  ? userProfile.age + " yrs"
                  : "28 yrs";
              strgender =
                  userProfile.gender.isNotEmpty ? userProfile.gender : "Male";
              strheight = userProfile.userHeight;
              strweight = userProfile.userWeight;
              strdob = userProfile.dob;
              strcity = userProfile.city;
              strstate = userProfile.state;
              stroccupation = userProfile.occupation;
              streducation = userProfile.education;
              strbio = userProfile.bio;
              strpincode = userProfile.pincode;
              strstatus =
                  userProfile.status.isNotEmpty ? userProfile.status : "Single";
              strcast = userProfile.cast;
              strreligion = userProfile.religion;
              _familyList = userProfile.family;
              _hobbyList = userProfile.hobbies;
              if (userProfile.hobbies.length > 0) {
                for (int i = 0; i < userProfile.hobbies.length; i++) {
                  if (i == 0) {
                    strhobbies = userProfile.hobbies.elementAt(i).hobby;
                  } else {
                    if (!strhobbies
                        .contains(userProfile.hobbies.elementAt(i).hobby)) {
                      strhobbies = strhobbies +
                          "," +
                          userProfile.hobbies.elementAt(i).hobby;
                    }
                  }
                }
              } else {
                strhobbies = "add";
              }

              _languageList = userProfile.languages;
              strmothertounge = userProfile.mother_tounge;

              applyLanguage(userProfile.languages);

              strdrinking = userProfile.drinking;
              streating = userProfile.eating;
              strsmoking = userProfile.smoking;
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

  Future<void> fetchPrefDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final PrefrenceModel prefrenceModel =
              await API_Manager.FetchUserPrefrence(id!);

          if (prefrenceModel.error != true) {
            UserPrefrence userPrefrence = prefrenceModel.userPrefrence.first;

            setState(() {
              _isLoading = false;
              strAgeFrom = userPrefrence.ageFrom.isNotEmpty
                  ? userPrefrence.ageFrom
                  : "18";
              strAgeTo =
                  userPrefrence.ageTo.isNotEmpty ? userPrefrence.ageTo : "20";
              strHeightFrom = userPrefrence.heightFrom;
              strHeightTo = userPrefrence.heightTo;
              strPrefEdu = userPrefrence.education;
              strPrefCast = userPrefrence.cast;
              strPrefLoc = userPrefrence.location;
              strprefincome = userPrefrence.income;
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
        _sample = sample;
        _file = file;

        // final bytes = Io.File(_imageFile.path).readAsBytesSync();
        // Uri uri = Uri.file(_imageFile.path);
        // String strextension = uri.pathSegments.last.split(".").last;
        //
        // String imagename = strname.toLowerCase().replaceAll(" ", "")+id!+"_prImg.$strextension";
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

    if (results.containsKey('img64')) {
      setState(() {
        _lastCropped = results['_lastCropped'];
      });

      String strextension = results['strextension'];

      String imagename = strname.toLowerCase().replaceAll(" ", "") +
          id! +
          "_prImg.$strextension";

      updateImage(results['img64'], imagename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
              children: [
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                userProfile(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                tabBar(),
                isSelected == 'preferences'
                    ? patnerPreferences()
                    : isSelected == 'details'
                        ? personalDetails()
                        : familyDetails(),
              ],
            ),
    );
  }

  userProfile() {
    return Column(
      children: [
        GestureDetector(
          onTap: checkPermission,
          child: strimgurl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(strimgurl,
                      height: 160, width: 160, fit: BoxFit.cover),
                )
              : Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: const DecorationImage(
                      image: AssetImage('assets/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        heightSpace,
        Text(
          strname,
          style: black14BoldTextStyle,
        ),
        Text(
          '$strage  •  $stroccupation',
          style: grey12SemiBoldTextStyle,
        ),
        Text(
          '$strcity, $strstate',
          style: grey12RegularTextStyle,
        ),
        heightSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(fixPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Image.asset(
                'assets/icons/chat.png',
                color: whiteColor,
                height: 15,
                width: 15,
              ),
            ),
            widthSpace,
            widthSpace,
            Container(
              padding: const EdgeInsets.all(fixPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Icon(
                Icons.call_outlined,
                color: whiteColor,
                size: 15,
              ),
            ),
          ],
        ),
        heightSpace,
        Text(
          strbio,
          textAlign: TextAlign.center,
          style: grey12RegularTextStyle,
        ),
      ],
    );
  }

  tabBar() {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSelected = 'details';
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected == 'details'
                        ? primaryColor
                        : Colors.transparent,
                    borderRadius: isSelected == 'details'
                        ? BorderRadius.circular(25)
                        : null,
                    // border: Border(
                    //   bottom: BorderSide(
                    //     color: isSelected == 'details' ? primaryColor : greyColor,
                    //     width: 3.5,
                    //   ),
                    // ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Personal Details',
                        style: TextStyle(
                          color: isSelected == 'details'
                              ? Colors.white
                              : blackColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // widthSpace,
                      // isSelected == 'details'
                      //     ? InkWell(
                      //         onTap: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => const EditDetails()),
                      //         ).then((value) {
                      //           fetchDetails();
                      //         }),
                      //         child: Image.asset(
                      //           'assets/icons/edit.png',
                      //           color: Colors.white,
                      //           height: _editIconSize,
                      //           width: _editIconSize,
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSelected = 'preferences';
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected == 'preferences'
                        ? primaryColor
                        : Colors.transparent,
                    borderRadius: isSelected == 'preferences'
                        ? BorderRadius.circular(25)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Patner Preferences',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected == 'preferences'
                                ? Colors.white
                                : blackColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // widthSpace,
                      // isSelected == 'preferences'
                      //     ? InkWell(
                      //         onTap: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const EditPreferences()),
                      //         ).then((value) {
                      //           fetchPrefDetails();
                      //         }),
                      //         child: Image.asset(
                      //           'assets/icons/edit.png',
                      //           color: blackColor,
                      //           height: _editIconSize,
                      //           width: _editIconSize,
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSelected = 'family';
                  });
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected == 'family'
                        ? primaryColor
                        : Colors.transparent,
                    borderRadius: isSelected == 'family'
                        ? BorderRadius.circular(25)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Family Details',
                        style: TextStyle(
                          color: isSelected == 'family'
                              ? Colors.white
                              : blackColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // widthSpace,
                      // isSelected == 'family'
                      //     ? InkWell(
                      //         onTap: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) =>
                      //                   const EditPreferences()),
                      //         ).then((value) {
                      //           fetchPrefDetails();
                      //         }),
                      //         child: Image.asset(
                      //           'assets/icons/edit.png',
                      //           color: blackColor,
                      //           height: _editIconSize,
                      //           width: _editIconSize,
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  personalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        name(),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: age(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: gender(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: height(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: weight(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(child: dob()),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(child: status()),
          ],
        ),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: education(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: cast(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(child: language()),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(child: mothertounge()),
          ],
        ),
        heightSpace,
        heightSpace,
        occupation(),
        heightSpace,
        heightSpace,
        IntrinsicHeight(
          child: Row(
            children: [
              livesIn(),
              widthSpace,
              widthSpace,
              widthSpace,
              pincode(),
            ],
          ),
        ),
        heightSpace,
        heightSpace,
        Row(
          children: [
            religion(),
            widthSpace,
            widthSpace,
            widthSpace,
            hobbies(),
          ],
        ),
        heightSpace,
        heightSpace,
        // SizedBox(
        //   height: 150,
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: <Widget>[
        //       Expanded(
        //         child: family(),
        //       ),
        //       widthSpace,
        //       widthSpace,
        //       widthSpace,
        //       Expanded(
        //         child: habits(),
        //       ),
        //     ],
        //   ),
        // ),
        habits(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace
      ],
    );
  }

  familyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: familyStatusDropdown(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: familyValuesDropdown(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: familyTypeDropdown(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: familyIncomeDropdown(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: fatherOccupationDropdown(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: motherOccupationDropdown(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        Row(
          children: [
            Expanded(
              child: brotherDropdown(),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: ofWhichMarriedDropdown(),
            ),
          ],
        ),
        heightSpace,
        heightSpace,
        heightSpace,
        sisterDropdown(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        Text(
          "Family based out of",
          style: black15BoldTextStyle.copyWith(fontSize: 18),
        ),
        heightSpace,
        heightSpace,
        // livesInField(),
        countryDropdown(),

        heightSpace,
        heightSpace,
        stateDropdown(),
        heightSpace,
        heightSpace,

        cityDropdown(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
      ],
    );
  }

  livesInField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CSCPicker(
          showStates: true,
          currentCountry: country,
          disableCountry: false,
          currentCity: city,
          currentState: state,
          showCities: true,
          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
          dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1)),
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1)),
          selectedItemStyle: black13MediumTextStyle,
          dropdownHeadingStyle: black13RegularTextStyle,
          dropdownItemStyle: black13RegularTextStyle,
          dropdownDialogRadius: 10.0,
          searchBarRadius: 10.0,
          onCountryChanged: (value) {
            if (value.length > 0) {
              setState(() {
                selectedCountry = value;
              });
            }
          },
          onStateChanged: (value) {
            setState(() {
              selectedState = value!;
            });
          },
          onCityChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCity = value;
              });
            }
          },
        ),
      ],
    );
  }

  countryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Country",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            country,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Sister(s)",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strsister,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strsister = newValue!;
          //       });
          //     },
          //     items: sisters.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  stateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "State",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            state,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Sister(s)",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strsister,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strsister = newValue!;
          //       });
          //     },
          //     items: sisters.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  cityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "City",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            city,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Sister(s)",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strsister,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strsister = newValue!;
          //       });
          //     },
          //     items: sisters.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  familyStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Status',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strfstatus,
            // textAlign: TextAlign.start,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       'Select Family Status',
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strfstatus,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strfstatus = newValue;
          //       });
          //     },
          //     items: familyStatus.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  familyValuesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Values',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strfvalues,
            style: black13RegularTextStyle,
          ),

          // DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       'Select Family Values',
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strfvalues,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strfvalues = newValue!;
          //       });
          //     },
          //     items: familyValues.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  familyTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Type',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strftype,
            style: black13RegularTextStyle,
          ),

          // DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       'Select Family Type',
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strftype,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strftype = newValue!;
          //       });
          //     },
          //     items: familyType.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  familyIncomeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Income',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strfincome,
            style: black13RegularTextStyle,
          ),
          // DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       'Select Family Income',
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strfincome,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strfincome = newValue!;
          //       });
          //     },
          //     items: familyIncome.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  fatherOccupationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Father's Occupation",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strfatherOccupation,
            style: black13RegularTextStyle,
          ),

          // DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Father's Occupation",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strfatherOccupation,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strfatherOccupation = newValue!;
          //       });
          //     },
          //     items: fatherOccupation
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  motherOccupationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mother's Occupation",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strmotherOccupation,
            style: black13RegularTextStyle,
          ),
          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Mother's Occupation",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strmotherOccupation,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strmotherOccupation = newValue!;
          //       });
          //     },
          //     items: motherOccupation
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  brotherDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brother(s)",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strbrother,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Brother(s)",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strbrother,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strbrother = newValue!;
          //       });
          //     },
          //     items: brothers.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  sisterDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sister(s)",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strsister,
            style: black13RegularTextStyle,
          ),

          //  DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Sister(s)",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strsister,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strsister = newValue!;
          //       });
          //     },
          //     items: sisters.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  ofWhichMarriedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Of which married",
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          alignment: Alignment.centerLeft,

          width: double.infinity,
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strofwhichmarried,
            style: black13RegularTextStyle,
          ),

          // DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: const InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value) {
          //       // if (value == null || value == "") {
          //       //   return 'Please select family status';
          //       // } else {
          //       //   return null;
          //       // }
          //     },
          //     hint: Text(
          //       "Select Of which married",
          //       style: black13RegularTextStyle,
          //     ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: strofwhichmarried,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         strofwhichmarried = newValue!;
          //       });
          //     },
          //     items: <String>["None", "1"]
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strname,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  age() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strage!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  gender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strgender!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  height() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strheight!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  weight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strweight!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  dob() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strdob!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strstatus!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  education() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            streducation,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  cast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strcast!,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  mothertounge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mother Tounge',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strmothertounge,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  language() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strlanguage,
                  style: black13MediumTextStyle,
                ),
              ),
              SizedBox(
                  height: 15,
                  width: 15,
                  child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LanguagesDialog(id!, _languageList);
                            }).then((value) {
                          fetchDetails();
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: primaryColor,
                        size: 15,
                      )))
            ],
          ),
        ),
      ],
    );
  }

  hobbies() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hobbies',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    strhobbies,
                    style: black13MediumTextStyle,
                  ),
                ),
                SizedBox(
                    height: 15,
                    width: 15,
                    child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          if (_hobbyList.length < 5) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return HobbiesDialog(id!, _hobbyList);
                                }).then((value) {
                              fetchDetails();
                            });
                          } else {
                            showSnackBar(context,
                                'Sorry! you cant add more than 5 hobbies!!');
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: primaryColor,
                          size: 15,
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }

  family() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _familyList.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _familyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                            _familyList.elementAt(index).relation +
                                ": " +
                                _familyList.elementAt(index).name,
                            style: black13MediumTextStyle,
                          );
                        })
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'add',
                            style: black13MediumTextStyle,
                          ),
                        ],
                      ),
              ),
              SizedBox(
                  height: 15,
                  width: 15,
                  child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FamilyDialog(id!, _familyList);
                            }).then((value) {
                          fetchDetails();
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: primaryColor,
                        size: 15,
                      )))
            ],
          ),
        ),
      ],
    );
  }

  habits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habits',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Drinking: $strdrinking',
                      style: black13MediumTextStyle,
                    ),
                    heightSpace,
                    Text(
                      'Eating: $streating',
                      style: black13MediumTextStyle,
                    ),
                    heightSpace,
                    Text(
                      'Smoking: $strsmoking',
                      style: black13MediumTextStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 15,
                  width: 15,
                  child: IconButton(
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return HabitsDialog(
                                  id!, strdrinking, streating, strsmoking);
                            }).then((value) {
                          fetchDetails();
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: primaryColor,
                        size: 15,
                      )))
            ],
          ),
        ),
      ],
    );
  }

  occupation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Occupation',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            stroccupation,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  religion() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Religion',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              strreligion,
              style: black13MediumTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  pincode() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pincode',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              strpincode,
              style: black13MediumTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  livesIn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lives In',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$strcity, $strstate',
              style: black13MediumTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  patnerPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
        preferenceAge(),
        heightSpace,
        heightSpace,
        preferenceHeight(),
        heightSpace,
        heightSpace,
        preferenceEducation(),
        heightSpace,
        heightSpace,
        preferenceIncome(),
        heightSpace,
        heightSpace,
        preferenceReligion(),
        heightSpace,
        heightSpace,
        preferenceLocation(),
        heightSpace,
        heightSpace,
        heightSpace,
        heightSpace,
      ],
    );
  }

  preferenceAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: grey13SemiBoldTextStyle,
                    ),
                    Text(
                      strAgeFrom,
                      style: black13MediumTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: grey13SemiBoldTextStyle,
                    ),
                    Text(
                      strAgeTo,
                      style: black13MediumTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  preferenceHeight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Height',
              style: black15BoldTextStyle,
            ),
            Text(
              ' (Ft In)',
              style: black13RegularTextStyle,
            ),
          ],
        ),
        heightSpace,
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: grey13SemiBoldTextStyle,
                    ),
                    Text(
                      strHeightFrom,
                      style: black13MediumTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            widthSpace,
            widthSpace,
            widthSpace,
            widthSpace,
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: grey13SemiBoldTextStyle,
                    ),
                    Text(
                      strHeightTo,
                      style: black13MediumTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  preferenceEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strPrefEdu,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  preferenceIncome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Income',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strprefincome,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  preferenceReligion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strPrefCast,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  preferenceLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            strPrefLoc,
            style: black13MediumTextStyle,
          ),
        ),
      ],
    );
  }

  Future<void> updateImage(String img64, String imagename) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel =
              await API_Manager.updateProfilePicture(img64, imagename, id!);

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
              _sample = null;
            });

            showSnackBar(context, resultModel.message);
            imageCache.clear();
            fetchDetails();
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

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void applyLanguage(List<Language> languages) {
    if (languages.length > 0) {
      for (int i = 0; i < languages.length; i++) {
        if (i == 0) {
          strlanguage = languages.elementAt(i).language;
        } else {
          if (!strlanguage.contains(languages.elementAt(i).language)) {
            strlanguage = strlanguage + "," + languages.elementAt(i).language;
          }
        }
      }
    } else {
      strlanguage = "add";
    }
  }
}

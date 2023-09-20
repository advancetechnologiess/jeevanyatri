import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';
import '../crop_image_screen.dart';
import '../screens.dart';
import 'edit_family_dialog.dart';
import 'edit_habits_dialog.dart';
import 'edit_hobbies_dialog.dart';
import 'edit_languages_dialog.dart';

class UserProfileDetails extends StatefulWidget {
  const UserProfileDetails({Key? key}) : super(key: key);

  @override
  State<UserProfileDetails> createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends State<UserProfileDetails> {
  String? id;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Io.File? _file;
  Io.File? _sample;
  Io.File? _lastCropped;
  String strimgurl = "",
      strage = "",
      stroccupation = "",
      strbio = "",
      strcity = "",
      strstate = "";
  String strname = "User",
      strhobbies = "",
      strdrinking = "",
      streating = "",
      strsmoking = "",
      strlanguage = "";
  List<Hobby> _hobbyList = <Hobby>[];
  List<Language> _languageList = <Language>[];
  List<Family> _familyList = <Family>[];

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
      id = sid;
    });

    fetchDetails();
    // fetchPrefDetails();
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
              // strgender = userProfile.gender.isNotEmpty ? userProfile.gender  : "Male";
              // strheight = userProfile.userHeight;
              // strweight = userProfile.userWeight;
              // strdob = userProfile.dob;
              strcity = userProfile.city;
              strstate = userProfile.state;
              stroccupation = userProfile.occupation;
              // streducation = userProfile.education;
              strbio = userProfile.bio;
              // strstatus = userProfile.status.isNotEmpty ? userProfile.status  : "Single";
              // strcast = userProfile.cast;

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
      print("Image picker error $e");
    }
  }

  Future<void> _cropImage() async {
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return new CropImgScreen(sample: _sample, file: _file);
        },
      ),
    );

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
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
                language(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                hobbies(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                family(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                habits()
                // tabBar(),
                // isSelected == 'preferences' ? patnerPreferences() : personalDetails(),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  hobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Hobbies',
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
    );
  }

  family() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Family',
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
          'My Habits',
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

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

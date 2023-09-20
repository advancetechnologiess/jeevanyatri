import 'package:csc_picker/csc_picker.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/educations_model.dart';
import '../../models/preference_model.dart';
import '../../models/result_model.dart';

class EditPreferences extends StatefulWidget {
  const EditPreferences({Key? key}) : super(key: key);

  @override
  _EditPreferencesState createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
  String? ageFrom = "18";
  String? ageTo = "20";
  String? heightFrom;
  String? heightTo;
  String? religion = "Hindu";
  String? id;
  String caste = 'Any';
  String income = "";
  String? country, state, city, degree, education;
  String? _selectedCountry, _selectedState, _selectedCity;

  TextEditingController _educationController = TextEditingController();
  TextEditingController _castController = TextEditingController();
  TextEditingController _subcastController = TextEditingController();

  bool _isLoading = false, isManglik = false, isNRI = false;
  List<Education> _educationList = <Education>[];
  Education? _selectedEducation;
  var prefCastArray = <String>[];
  var prefQulfnArray = <String>[];

  @override
  void initState() {
    super.initState();
    income = incomeArray.first;
    prefCastArray.add('Any');
    prefCastArray.addAll(castArray);
    if (prefCastArray.contains('Other')) {
      prefCastArray.remove('Other');
    }
    prefQulfnArray.add('Any');
    prefQulfnArray.addAll(qualificationArray);
    if (prefQulfnArray.contains('Other')) {
      prefQulfnArray.remove('Other');
    }
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
    });

    fetchDetails();
    // fetchEducationsList();
  }

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final PrefrenceModel prefrenceModel =
              await API_Manager.FetchUserPrefrence(id!);

          if (prefrenceModel.error != true) {
            UserPrefrence userPrefrence = prefrenceModel.userPrefrence.first;

            setState(() {
              // _isLoading = false;
              ageFrom = userPrefrence.ageFrom.isNotEmpty
                  ? userPrefrence.ageFrom
                  : "18";
              ageTo =
                  userPrefrence.ageTo.isNotEmpty ? userPrefrence.ageTo : "20";
              heightFrom = userPrefrence.heightFrom;
              heightTo = userPrefrence.heightTo;

              education = userPrefrence.education;
              _educationController =
                  TextEditingController(text: userPrefrence.education);
              _castController = TextEditingController(text: userPrefrence.cast);

              if (prefCastArray.contains(userPrefrence.cast)) {
                caste = userPrefrence.cast;
              }

              if (incomeArray.contains(userPrefrence.income)) {
                income = userPrefrence.income;
              }

              _subcastController =
                  TextEditingController(text: userPrefrence.subcast);

              degree = userPrefrence.qualifications;
              isManglik = userPrefrence.isManglik;
              isNRI = userPrefrence.isNRI;
              city = userPrefrence.city;
              state = userPrefrence.state;
              country = userPrefrence.country;
              religion = userPrefrence.religion.isNotEmpty
                  ? userPrefrence.religion
                  : "Any";
            });

            debugPrint('city $city');
            debugPrint('state $state');
          } else {
            setState(() {
              // _isLoading = false;
            });
          }

          fetchEducationsList();
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

  Future<void> fetchEducationsList() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final EducationModel educationModel =
              await API_Manager.fetchEducationsList();

          if (educationModel.error != true) {
            List<Education> _prefeducationList = <Education>[];
            _prefeducationList.add(Education(id: "0", education: 'Any'));
            _prefeducationList.addAll(educationModel.educations);
            setState(() {
              _isLoading = false;
              _educationList = _prefeducationList;
            });

            if (education!.isNotEmpty || education != null) {
              for (int i = 0; i < _educationList.length; i++) {
                if (education == _educationList.elementAt(i).education) {
                  setState(() {
                    _selectedEducation = _educationList.elementAt(i);
                  });
                }
              }
            }
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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(
          'Edit Preferences',
          style: black20BoldTextStyle,
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
                age(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                heightFields(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    degreeDropdown(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    degree == "Graduate"
                        ? educationDropdown()
                        : educationTextfield(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                castDropdown(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                incomeDropdown(),
                // Row(
                //   children: [
                //     religionDropdown(),
                //     widthSpace,
                //     widthSpace,
                //     widthSpace,
                //     widthSpace,
                //     castDropdown(),//castTextField(),
                //   ],
                // ),
                Row(
                  children: [
                    // subcastTextField(),
                    // widthSpace,
                    // widthSpace,
                    manglikField(),
                    widthSpace,
                    widthSpace,
                    nriField()
                  ],
                ),
                heightSpace,
                heightSpace,
                livesInField(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    cancelButton(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    doneButton(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
              ],
            ),
    );
  }

  age() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        elevation: 4,
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Select min age';
                          } else {
                            return null;
                          }
                        },
                        hint: Text(
                          'Min Age',
                          style: black13RegularTextStyle,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryColor,
                          size: 20,
                        ),
                        value: ageFrom,
                        style: black13RegularTextStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            ageFrom = newValue;
                          });
                        },
                        items: ageArray
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        elevation: 4,
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Select max age';
                          } else {
                            return null;
                          }
                        },
                        hint: Text(
                          'Max Age',
                          style: black13RegularTextStyle,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryColor,
                        ),
                        value: ageTo,
                        style: black13RegularTextStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            ageTo = newValue;
                          });
                        },
                        items: ageArray
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  heightFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Text(
          'Height ',
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
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        elevation: 4,
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Select min height';
                          } else {
                            return null;
                          }
                        },
                        hint: Text(
                          'Min Height',
                          style: black13RegularTextStyle,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryColor,
                          size: 20,
                        ),
                        value: heightFrom,
                        style: black13RegularTextStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            heightFrom = newValue;
                          });
                        },
                        items: heightarray
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        isExpanded: true,
                        elevation: 4,
                        isDense: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Select max height';
                          } else {
                            return null;
                          }
                        },
                        hint: Text(
                          'Max Height',
                          style: black13RegularTextStyle,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryColor,
                          size: 20,
                        ),
                        value: heightTo,
                        style: black13RegularTextStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            heightTo = newValue;
                          });
                        },
                        items: heightarray
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  degreeDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qualifications',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: fixPadding / 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                elevation: 4,
                isDense: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Select qualification';
                  } else {
                    return null;
                  }
                },
                hint: Text(
                  'select qualification',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: degree,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    degree = newValue;
                  });
                },
                items: prefQulfnArray
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  educationTextfield() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _educationController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  educationDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: fixPadding / 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                elevation: 4,
                isDense: true,
                hint: Text(
                  'Select Education',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: _selectedEducation,
                style: black13RegularTextStyle,
                onChanged: (Education? newValue) {
                  setState(() {
                    _selectedEducation = newValue;
                    education = newValue!.education;
                  });
                },
                items: _educationList
                    .map<DropdownMenuItem<Education>>((Education value) {
                  return DropdownMenuItem<Education>(
                    value: value,
                    child: Text(value.education),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  religionDropdown() {
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
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: fixPadding / 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                elevation: 4,
                isDense: true,
                hint: Text(
                  'Hindu',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: religion,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    religion = newValue;
                  });
                },
                items: <String>[
                  'Any',
                  'Hindu',
                  'Christian',
                  'Muslim',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  livesInField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lives In',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        CSCPicker(
          ///Enable disable state dropdown [OPTIONAL PARAMETER]
          showStates: true,
          currentCountry: country,
          disableCountry: false,
          // defaultCountry: country!.isNotEmpty ? DefaultCountry.values.firstWhere((e) => e.toString() == 'DefaultCountry.' + country!)
          // : DefaultCountry.India,
          currentCity: city,
          currentState: state,
          // stateDropdownLabel: ,
          /// Enable disable city drop down [OPTIONAL PARAMETER]
          showCities: true,

          ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
          dropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1)),

          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
          disabledDropdownDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1)),

          ///selected item style [OPTIONAL PARAMETER]
          selectedItemStyle: black13MediumTextStyle,

          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
          dropdownHeadingStyle: black13RegularTextStyle,

          ///DropdownDialog Item style [OPTIONAL PARAMETER]
          dropdownItemStyle: black13RegularTextStyle,

          ///Dialog box radius [OPTIONAL PARAMETER]
          dropdownDialogRadius: 10.0,

          ///Search bar radius [OPTIONAL PARAMETER]
          searchBarRadius: 10.0,

          ///triggers once country selected in dropdown
          onCountryChanged: (value) {
            if (value != null && value.length > 0) {
              setState(() {
                ///store value in country variable
                _selectedCountry = value;
              });
            }
          },

          ///triggers once state selected in dropdown
          onStateChanged: (value) {
            setState(() {
              ///store value in state variable
              _selectedState = value;
            });
          },

          ///triggers once city selected in dropdown
          onCityChanged: (value) {
            if (value != null) {
              setState(() {
                ///store value in city variable
                _selectedCity = value;
              });
            }
          },
        ),
      ],
    );
  }

  castDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: const InputDecoration.collapsed(hintText: ''),
              isExpanded: true,
              elevation: 4,
              isDense: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value == "") {
                  return 'Please select cast';
                } else
                  return null;
              },
              hint: Text(
                'Select',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: caste,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  caste = newValue!;
                });
              },
              items:
                  prefCastArray.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  incomeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual Income',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: fixPadding / 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: const InputDecoration.collapsed(hintText: ''),
              isExpanded: true,
              elevation: 4,
              isDense: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value == "") {
                  return 'Please select prefered income';
                } else
                  return null;
              },
              hint: Text(
                'Select',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: income,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  income = newValue!;
                });
              },
              items: incomeArray.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  castTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cast',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _castController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  subcastTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subcast',
            style: black15BoldTextStyle,
          ),
          heightSpace,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: fixPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _subcastController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  manglikField() {
    return Expanded(
      child: Column(
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: <Widget>[
              Text(
                'Manglik',
                style: black15BoldTextStyle,
              ), //Text
              Checkbox(
                value: isManglik,
                onChanged: (bool? value) {
                  setState(() {
                    isManglik = value!;
                  });
                },
                activeColor: primaryColor,
              ), //Checkbox
            ], //<Widget>[]
          ),
        ],
      ),
    );
  }

  nriField() {
    return Expanded(
      child: Column(
        children: [
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: <Widget>[
              Text(
                'NRI',
                style: black15BoldTextStyle,
              ), //Text
              Checkbox(
                value: isNRI,
                onChanged: (bool? value) {
                  setState(() {
                    isNRI = value!;
                  });
                },
                activeColor: primaryColor,
              ), //Checkbox
            ], //<Widget>[]
          ),
        ],
      ),
    );
  }

  cancelButton() {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(fixPadding),
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
    );
  }

  doneButton() {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_selectedCountry != null && _selectedCountry != "") {
            setState(() {
              country = _selectedCountry;
            });
          }
          if (_selectedState != null && _selectedState != "") {
            setState(() {
              state = _selectedState;
            });
          }
          if (_selectedCity != null && _selectedCity != "") {
            setState(() {
              city = _selectedCity;
            });
          }
          updateDetails();
        },
        child: Container(
          padding: const EdgeInsets.all(fixPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'Done',
            style: white16BoldTextStyle,
          ),
        ),
      ),
    );
  }

  Future<void> updateDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel =
              await API_Manager.updatePartnerPrefrence(
                  id!,
                  ageFrom!,
                  ageTo!,
                  heightFrom!,
                  heightTo!,
                  degree!,
                  _educationController.text,
                  "",
                  isManglik.toString(),
                  isNRI.toString(),
                  religion!,
                  caste,
                  _subcastController.text,
                  city!,
                  state!,
                  country!,
                  income);

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, resultModel.message);

            Navigator.pop(context);
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
}

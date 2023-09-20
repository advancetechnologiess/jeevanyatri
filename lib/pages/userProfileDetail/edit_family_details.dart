import 'package:csc_picker/csc_picker.dart';
import 'package:meet_me/api/api_manager.dart';
import 'package:meet_me/constants/prefs.dart';
import 'package:meet_me/helpers/connection_utils.dart';
import 'package:meet_me/models/family_details_model.dart';
import 'package:meet_me/models/preference_model.dart';
import 'package:meet_me/models/result_model.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFamily extends StatefulWidget {
  const EditFamily({Key? key}) : super(key: key);

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> {
  String? strfstatus,
      strfvalues,
      strftype,
      strfincome,
      strfatherOccupation,
      strmotherOccupation,
      strbrother,
      strsister,
      strofwhichmarried,
      country,
      city,
      state,
      selectedCountry,
      selectedState,
      selectedCity;
  String? id;

  Future<void> getsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool(Prefs.isLoggedIn) ?? false;
    // String? strgroup = prefs.getString(Constants.GROUP);
    String? sid = prefs.getString(Prefs.USER_ID);

    print(sid);
    setState(() {
      id = sid!;
    });

    fetchFamilyDetails();
    // fetchEducationsList();
  }

  Future<void> fetchFamilyDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
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

  @override
  void initState() {
    getsharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(
          'Edit Family Details',
          style: black20BoldTextStyle,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                child: Column(
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
                    livesInField(),
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
                  ],
                ),
              ),
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
          if (selectedCountry != null && selectedCountry != "") {
            setState(() {
              country = selectedCountry;
            });
          }
          if (selectedState != null && selectedState != "") {
            setState(() {
              state = selectedState;
            });
          }
          if (selectedCity != null && selectedCity != "") {
            setState(() {
              city = selectedCity;
            });
          }
          insetFamilyDetails();
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

  bool _isLoading = false;
  Future<void> insetFamilyDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel = await API_Manager.InsertFamilyDetails(
            id!,
            strfstatus!,
            strfvalues!,
            strftype!,
            strfincome!,
            strfatherOccupation!,
            strmotherOccupation!,
            strbrother!,
            strofwhichmarried!,
            strsister!,
            country!,
            state!,
            city!,
          );

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, resultModel.message);

            Navigator.pop(context);
          } else if (resultModel.message ==
              "User Family Details Already Added!") {
            updateFamilyDetails();
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

  Future<void> updateFamilyDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel = await API_Manager.UpdateFamilyDetails(
            id!,
            strfstatus!,
            strfvalues!,
            strftype!,
            strfincome!,
            strfatherOccupation!,
            strmotherOccupation!,
            strbrother!,
            strofwhichmarried!,
            strsister!,
            country!,
            state!,
            city!,
          );

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
            if (value != null && value.length > 0) {
              setState(() {
                selectedCountry = value;
              });
            }
          },
          onStateChanged: (value) {
            setState(() {
              selectedState = value;
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
                  return 'Please select family status';
                } else {
                  return null;
                }
              },
              hint: Text(
                'Select Family Status',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strfstatus,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strfstatus = newValue;
                });
              },
              items: familyStatus.map<DropdownMenuItem<String>>((String value) {
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
                  return 'Please select family values';
                } else {
                  return null;
                }
              },
              hint: Text(
                'Select Family Values',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strfvalues,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strfvalues = newValue;
                });
              },
              items: familyValues.map<DropdownMenuItem<String>>((String value) {
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
                  return 'Please select family type';
                } else {
                  return null;
                }
              },
              hint: Text(
                'Select Family Type',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strftype,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strftype = newValue;
                });
              },
              items: familyType.map<DropdownMenuItem<String>>((String value) {
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
                  return 'Please select family income';
                } else {
                  return null;
                }
              },
              hint: Text(
                'Select Family Income',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strfincome,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strfincome = newValue;
                });
              },
              items: familyIncome.map<DropdownMenuItem<String>>((String value) {
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
          // height: 40,
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
                  return "Please select father's occupation";
                } else {
                  return null;
                }
              },
              hint: Text(
                "Select Father's Occupation",
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strfatherOccupation,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strfatherOccupation = newValue;
                });
              },
              items: fatherOccupation
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
                  return "Please select mother's occupation";
                } else {
                  return null;
                }
              },
              hint: Text(
                "Select Mother's Occupation",
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strmotherOccupation,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strmotherOccupation = newValue;
                });
              },
              items: motherOccupation
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
                  return 'Please select brother(s)';
                } else {
                  return null;
                }
              },
              hint: Text(
                "Select Brother(s)",
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strbrother,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strbrother = newValue;
                });
              },
              items: brothers.map<DropdownMenuItem<String>>((String value) {
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
                  return 'Please select sister(s)';
                } else {
                  return null;
                }
              },
              hint: Text(
                "Select Sister(s)",
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strsister,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strsister = newValue;
                });
              },
              items: sisters.map<DropdownMenuItem<String>>((String value) {
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
                  return 'Please select 0f which married';
                } else {
                  return null;
                }
              },
              hint: Text(
                "Select Of which married",
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: strofwhichmarried,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  strofwhichmarried = newValue;
                });
              },
              items: <String>["None", "1"]
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
    );
  }
}

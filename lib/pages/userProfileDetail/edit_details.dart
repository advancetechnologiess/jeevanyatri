import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/constants/prefs.dart';
import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../helpers/connection_utils.dart';
import '../../models/educations_model.dart';
import '../../models/profile_model.dart';
import '../../models/result_model.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({Key? key}) : super(key: key);

  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  String? gender = "Male";
  String? strheight;
  String weight = "";
  String bio = "";
  String cast = 'Gujarati Patel';
  String subcast = "";
  String? country, state, city, degree, education;
  String? status = "Single";
  String? occupation = "Science Professional";
  String mothertounge = "Gujarati";

  String? religion = "Hindu";
  String? job_in = "Private Sector";
  String? age = "18";

  // String? occupation = "Software Developer";
  String? livesIn = "Delhi, India";
  TextEditingController nameController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  TextEditingController _bioController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _castController = TextEditingController();
  TextEditingController _subcastController = TextEditingController();
  TextEditingController _incomeController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  bool _isLoading = false, isManglik = false, isNRI = false;
  String id = "", email = "", income = "";
  final _formKey = GlobalKey<FormState>();
  List<Education> _educationList = <Education>[];
  Education? _selectedEducation;

  @override
  void initState() {
    super.initState();
    income = incomeArray.first;
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
          'Edit Details',
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
                nameTextField(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    dobTextField(),
                    widthSpace,
                    widthSpace,
                    _age(),
                    widthSpace,
                    widthSpace,
                    genderDropdown(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    heightDropdown(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    weightTextField(),
                  ],
                ),
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
                Row(
                  children: [
                    empDropdown(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    incomeDropdown(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    occupationDropdown(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    statusDropdown(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    castDropdown(),
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    widthSpace,
                    religionDropdown(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                mothertoungeTextfield(),
                // IntrinsicHeight(
                //   child: Row(
                //     children: [
                //       religionDropdown(),
                //       widthSpace,
                //       widthSpace,
                //       widthSpace,
                //       widthSpace,
                //       castDropdown(), //castTextField(),
                //     ],
                //   ),
                // ),
                // subcastTextField(),
                Row(
                  children: [
                    manglikField(),
                    widthSpace,
                    widthSpace,
                    nriField(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                livesInField(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                bioTextField(),
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

  nameTextField() {
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
          child: TextField(
            controller: nameController,
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
    );
  }

  bioTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
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
          child: TextField(
            controller: _bioController,
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
    );
  }

  /*
  ageDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age',
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
                  '28 yrs',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: age,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    age = newValue!;
                  });
                },
                items: <String>[
                  '18 yrs',
                  '19 yrs',
                  '20 yrs',
                  '21 yrs',
                  '22 yrs',
                  '23 yrs',
                  '24 yrs',
                  '25 yrs',
                  '26 yrs',
                  '27 yrs',
                  '28 yrs',
                  '29 yrs',
                  '30 yrs',
                  '31 yrs',
                  '32 yrs',
                  '33 yrs',
                  '34 yrs',
                  '35 yrs',
                  '36 yrs',
                  '37 yrs',
                  '38 yrs',
                  '39 yrs',
                  '40 yrs',
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

   */

  genderDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
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
              child: IgnorePointer(
                ignoring: true,
                child: DropdownButton(
                  isExpanded: true,
                  elevation: 4,
                  isDense: true,
                  hint: Text(
                    'Male',
                    style: black13RegularTextStyle,
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: primaryColor,
                    size: 20,
                  ),
                  value: gender,
                  style: black13RegularTextStyle,
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  heightDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Height',
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
                    return 'Please select height';
                  } else
                    return null;
                },
                hint: Text(
                  'Select Height',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: strheight,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    strheight = newValue;
                  });
                },
                items:
                    heightarray.map<DropdownMenuItem<String>>((String value) {
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

  weightTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight',
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
              controller: _weightController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              maxLength: 3,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                isDense: true,
                counterText: "",
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                // helperText: 'e.g 50 kg'
              ),
            ),
          ),
        ],
      ),
    );
  }

  castDropdown() {
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
                value: cast,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    cast = newValue!;
                  });
                },
                items: castArray.map<DropdownMenuItem<String>>((String value) {
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
    return Column(
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
                'Are you manglik?',
                style: black15BoldTextStyle,
              ), //Text
              Checkbox(
                value: isManglik,
                onChanged: (bool? value) {
                  setState(() {
                    isManglik = value!;
                  });
                  print("isManglik :" + isManglik.toString());
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
                'Are you NRI?',
                style: black15BoldTextStyle,
              ), //Text
              Checkbox(
                value: isNRI,
                onChanged: (bool? value) {
                  setState(() {
                    isNRI = value!;
                  });
                  print("isNRI :" + isNRI.toString());
                },
                activeColor: primaryColor,
              ), //Checkbox
            ], //<Widget>[]
          ),
        ],
      ),
    );
  }

  // weightDropdown() {
  //   return Expanded(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Weight',
  //           style: black15BoldTextStyle,
  //         ),
  //         heightSpace,
  //         Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: fixPadding,
  //             vertical: fixPadding / 2,
  //           ),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: greyColor),
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton(
  //               isExpanded: true,
  //               elevation: 0,
  //               isDense: true,
  //               hint: Text(
  //                 '70 kg',
  //                 style: black13RegularTextStyle,
  //               ),
  //               icon: const Icon(
  //                 Icons.keyboard_arrow_down,
  //                 color: primaryColor,
  //                 size: 20,
  //               ),
  //               value: weight,
  //               style: black13RegularTextStyle,
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   weight = newValue;
  //                 });
  //               },
  //               items: <String>['50 kg', '60 kg', '70 kg', '40 kg', '55 kg']
  //                   .map<DropdownMenuItem<String>>((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(value),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  dobTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
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
              controller: _dobController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('dd MMM yyyy').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    _dobController.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              },
            ),
          ),
        ],
      ),
    );
  }

  incomeTextField() {
    return Expanded(
      child: Column(
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
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _incomeController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              keyboardType: TextInputType.number,
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

  incomeDropdown() {
    return Expanded(
        child: Column(
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
                  return 'Please select annual income';
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
    ));
  }

  statusDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marital Status',
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
                  'Single',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: status,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue;
                  });
                },
                items: <String>[
                  'Single',
                  'Widower',
                  'Divorced',
                  'Awaiting Divorce'
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

  mothertoungeTextfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mother Tounge',
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
                  return 'Please select mother tounge';
                } else
                  return null;
              },
              hint: Text(
                'Select Mother Tounge',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: mothertounge,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  mothertounge = newValue!;
                });
              },
              items: <String>[
                "Gujarati",
                "Assamese",
                "Bangla",
                "Bodo",
                "Dogri",
                "Hindi",
                "Kashmiri",
                "Kannada",
                "Konkani",
                "Maithili",
                "Malayalam",
                "Manipuri",
                "Marathi",
                "Nepali",
                "Oriya",
                "Punjabi",
                "Tamil",
                "Telugu",
                "Santali",
                "Sindhi",
                "Urdu",
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
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                elevation: 4,
                isDense: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Please select religion';
                  } else
                    return null;
                },
                hint: Text(
                  'Select religion',
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
                  'Hindu',
                  'Christian',
                  'Muslim',
                  'Sikh',
                  'Buddhist',
                  'Jain',
                  'Parsi',
                  'Jewish',
                  'Bahai',
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
                items: qualificationArray
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

  empDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employeed In',
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
                  'Private Sector',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: job_in,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    job_in = newValue;
                  });
                },
                items: employementArray
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

  _age() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 3,
            vertical: fixPadding / 1.3,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            _dobController.text.isNotEmpty
                ? calculateAge(_dobController.text).toString()
                : "",
            style: black13RegularTextStyle,
          ),

          // DropdownButtonHideUnderline(
          //   child:  DropdownButtonFormField(
          //     decoration: InputDecoration.collapsed(hintText: ''),
          //     isExpanded: true,
          //     elevation: 4,
          //     isDense: true,
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     validator: (value){
          //       if(value==null || value=="")
          //       {
          //         return 'Select age';
          //       }
          //       else {
          //         return null;
          //       }
          //     },
          //     // hint: Text(
          //     //   'Min Age',
          //     //   style: black13RegularTextStyle,
          //     // ),
          //     icon: const Icon(
          //       Icons.keyboard_arrow_down,
          //       color: primaryColor,
          //       size: 20,
          //     ),
          //     value: age,
          //     style: black13RegularTextStyle,
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         age = newValue;
          //       });
          //     },
          //     items: ageArray.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(calculateAge(_dobController.text).toString()),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ),
      ],
    );
  }

  occupationDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Occupation',
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
                  'Science Professional',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: occupation,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    occupation = newValue;
                  });
                },
                items: occupationArray
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
          currentCity: city,
          currentState: state,
          currentCountry: country,

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
            if (value.length > 0) {
              setState(() {
                ///store value in country variable
                country = value;
              });
            }
          },

          ///triggers once state selected in dropdown
          onStateChanged: (value) {
            setState(() {
              ///store value in state variable
              state = value;
            });
          },

          ///triggers once city selected in dropdown
          onCityChanged: (value) {
            setState(() {
              ///store value in city variable
              city = value;
            });
          },
        ),
        heightSpace,
        heightSpace,
        pincodeTextField()
      ],
    );
  }

  pincodeTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: fixPadding,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: _pincodeController,
        cursorColor: primaryColor,
        style: black13MediumTextStyle,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
          counterText: "",
          hintText: "Pincode",
          hintStyle: black13RegularTextStyle,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 6,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your pincode';
          } else
            return null;
        },
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
          // cast = _castController.text;
          subcast = _subcastController.text;
          bio = _bioController.text;
          education =
              degree == "Graduate" ? education : _educationController.text;
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
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel = await API_Manager.updateProfile(
            nameController.text,
            email,
            _dobController.text.isNotEmpty
                ? calculateAge(_dobController.text).toString()
                : "",
            gender!,
            strheight!,
            _weightController.text,
            _dobController.text,
            status!,
            isManglik.toString(),
            isNRI.toString(),
            religion!,
            cast,
            subcast,
            bio,
            city!,
            state!,
            country!,
            id,
            degree!,
            education!,
            _occupationController.text,
            job_in!,
            income,
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

  Future<void> fetchDetails() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final ProfileModel profileModel =
              await API_Manager.FetchUserProfile(id);

          if (profileModel.error != true) {
            UserProfile userProfile = profileModel.userProfile.first;

            setState(() {
              // _isLoading = false;
              nameController = TextEditingController(text: userProfile.name);
              // age = userProfile.age.isNotEmpty ? userProfile.age + " yrs" : "28 yrs";
              gender =
                  userProfile.gender.isNotEmpty ? userProfile.gender : "Male";

              _weightController =
                  TextEditingController(text: userProfile.userWeight);
              _dobController = TextEditingController(text: userProfile.dob);
              status =
                  userProfile.status.isNotEmpty ? userProfile.status : "Single";
              religion = userProfile.religion != "Not Specified"
                  ? userProfile.religion
                  : "Hindu";
              _pincodeController =
                  TextEditingController(text: userProfile.pincode);
              _educationController =
                  TextEditingController(text: userProfile.education);
              _occupationController =
                  TextEditingController(text: userProfile.occupation);

              occupation = userProfile.occupation.isNotEmpty
                  ? userProfile.occupation
                  : "Science Professional";
              _castController = TextEditingController(text: userProfile.cast);
              education = userProfile.education;

              if (castArray.contains(userProfile.cast)) {
                cast = userProfile.cast;
              }

              if (incomeArray.contains(userProfile.annualIncome)) {
                income = userProfile.annualIncome;
              }

              _subcastController =
                  TextEditingController(text: userProfile.subcast);
              _bioController = TextEditingController(text: userProfile.bio);

              _incomeController =
                  TextEditingController(text: userProfile.annualIncome);

              strheight = userProfile.userHeight;
              isManglik = userProfile.isManglik;
              isNRI = userProfile.isNRI;
              degree = userProfile.qualifications;
              education = userProfile.education;
              job_in = userProfile.employeedIn;
              // job_in = "Private Sector";
              mothertounge = userProfile.mother_tounge.isNotEmpty
                  ? userProfile.mother_tounge
                  : "Gujarati";
              email = userProfile.email;
              city = userProfile.city;
              state = userProfile.state;
              country = userProfile.country;
              print('userProfile.qualifications : ' + degree!);

              // status = userProfile.status.isNotEmpty ? userProfile.status  : "Single";
              // religion = userProfile.religion.isNotEmpty ? userProfile.religion  : "Hindu";
            });
          } else {
            setState(() {
              // _isLoading = false;
            });

            //todo
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
      if (intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final EducationModel educationModel =
              await API_Manager.fetchEducationsList();

          if (educationModel.error != true) {
            setState(() {
              _isLoading = false;
              _educationList = educationModel.educations;
            });

            if (education!.isNotEmpty) {
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

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  int calculateAge(String birthDateString) {
    String datePattern = "dd MMM yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff;
  }
}

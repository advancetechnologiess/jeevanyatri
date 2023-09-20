import 'dart:convert';

import 'package:meet_me/pages/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter>{
  String? ageFrom = "18";
  String? ageTo = "40";
  String? heightFrom;
  String? heightTo;
  String? status = "Single";
  String? country;
  String? education;
  String? profession;
  String? religion = "Any";
  String? income;
  TextEditingController _cityController = TextEditingController();
  TextEditingController _castController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: Text(
          'Filter',
          style: black20BoldTextStyle,
        ),
      ),
      body: ListView(
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
          // height(),
          // heightSpace,
          // heightSpace,
          // heightSpace,
          maritalStatus(),
          heightSpace,
          heightSpace,
          heightSpace,
          // selectCountry(),
          // heightSpace,
          // heightSpace,
          // heightSpace,
          cityTextField(),
          heightSpace,
          heightSpace,
          heightSpace,
          // selectEducation(),
          // heightSpace,
          // heightSpace,
          // heightSpace,
          // selectProfession(),
          // heightSpace,
          // heightSpace,
          // heightSpace,
          selectReligion(),
          heightSpace,
          heightSpace,
          heightSpace,
          castTextField(),
          heightSpace,
          heightSpace,
          heightSpace,
          annualIncome(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          applyButton(),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
        ],
      ),
    );
  }

  age() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '01',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
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
                        border: Border.all(color: blackColor),
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 4,
                              isDense: true,
                              hint: Text(
                                '21',
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
                              items: <String>[
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                                '31',
                                '32',
                                '33',
                                '34',
                                '35',
                                '36',
                                '37',
                                '38',
                                '39',
                                '40',
                              ].map<DropdownMenuItem<String>>((String value) {
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
                        border: Border.all(color: blackColor),
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 4,
                              isDense: true,
                              hint: Text(
                                '25',
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
                              items: <String>[
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                                '31',
                                '32',
                                '33',
                                '34',
                                '35',
                                '36',
                                '37',
                                '38',
                                '39',
                                '40',
                              ].map<DropdownMenuItem<String>>((String value) {
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
          ),
        ),
      ],
    );
  }

  height() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '02',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    'Height ',
                    style: black15BoldTextStyle,
                  ),
                  Text(
                    '(Ft In)',
                    style: grey13SemiBoldTextStyle,
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
                        border: Border.all(color: blackColor),
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 4,
                              isDense: true,
                              hint: Text(
                                '4 ft 2 in',
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
                              items: <String>[
                                '3 ft 2 in',
                                '4 ft 2 in',
                                '5 ft 2 in',
                                '6 ft 2 in',
                                '7 ft 0 in',
                              ].map<DropdownMenuItem<String>>((String value) {
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
                        border: Border.all(color: blackColor),
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 4,
                              isDense: true,
                              hint: Text(
                                '5 ft 2 in',
                                style: black13RegularTextStyle,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: primaryColor,
                              ),
                              value: heightTo,
                              style: black13RegularTextStyle,
                              onChanged: (String? newValue) {
                                setState(() {
                                  heightTo = newValue;
                                });
                              },
                              items: <String>[
                                '3 ft 2 in',
                                '4 ft 2 in',
                                '5 ft 2 in',
                                '6 ft 2 in',
                                '7 ft 0 in',
                              ].map<DropdownMenuItem<String>>((String value) {
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
          ),
        ),
      ],
    );
  }

  maritalStatus() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '02',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
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
                  border: Border.all(color: blackColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 4,
                    isDense: true,
                    hint: Text(
                      'Single ',
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
                      'Divorced',
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
        ),
      ],
    );
  }

  selectCountry() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '04',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                'Country',
                style: black15BoldTextStyle,
              ),
              heightSpace,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: fixPadding / 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: blackColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 4,
                    isDense: true,
                    hint: Text(
                      'India',
                      style: black13RegularTextStyle,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: 20,
                    ),
                    value: country,
                    style: black13RegularTextStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        country = newValue;
                      });
                    },
                    items: <String>[
                      'Any',
                      'India',
                      'USA',
                      'Belize',
                      'Canada',
                      'Mexico',
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
        ),
      ],
    );
  }

  cityTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '03',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'City',
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
                  controller: _cityController,
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
        ),
      ],
    );
  }

  selectEducation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '06',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
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
                  border: Border.all(color: blackColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 4,
                    isDense: true,
                    hint: Text(
                      'Any',
                      style: black13RegularTextStyle,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: 20,
                    ),
                    value: education,
                    style: black13RegularTextStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        education = newValue;
                      });
                    },
                    items: <String>[
                      'Any',
                      'BCA',
                      'BBA',
                      'Bcom',
                      'MCA',
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
        ),
      ],
    );
  }

  selectProfession() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '07',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              Text(
                'Profession',
                style: black15BoldTextStyle,
              ),
              heightSpace,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: fixPadding,
                  vertical: fixPadding / 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: blackColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 4,
                    isDense: true,
                    hint: Text(
                      'Any',
                      style: black13RegularTextStyle,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: 20,
                    ),
                    value: profession,
                    style: black13RegularTextStyle,
                    onChanged: (String? newValue) {
                      setState(() {
                        profession = newValue;
                      });
                    },
                    items: <String>[
                      'Any',
                      'Software Engineer',
                      'CA',
                      'Doctor',
                      'Professor',
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
        ),
      ],
    );
  }

  selectReligion() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '04',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
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
                  border: Border.all(color: blackColor),
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
        ),
      ],
    );
  }

  castTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '05',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caste',
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
        ),
      ],
    );
  }

  annualIncome() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
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
          child: Text(
            '06',
            style: black13BoldTextStyle,
          ),
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
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
                  border: Border.all(color: blackColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 4,
                    isDense: true,
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
                        income = newValue;
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
          ),
        ),
      ],
    );
  }

  applyButton() {
    return Row(
      children: [
        Text(
          'Clear',
          style: primaryColor12BlackTextStyle,
        ),
        widthSpace,
        widthSpace,
        Expanded(
          child: InkWell(
            onTap: () async {

              var fieldsData = {
                'religion': religion,
                'ageFrom': ageFrom,
                'ageTo': ageTo,
                'status': status,
                'city':_cityController.text,
                'caste':_castController.text,
                'income': income
              };


              // String strjson = JsonEncoder()
              Navigator.pop(context,json.encode(fieldsData));
            },
            child: Container(
              padding: const EdgeInsets.all(fixPadding),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Apply',
                style: white16BoldTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }


}

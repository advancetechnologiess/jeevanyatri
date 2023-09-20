import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_me/pages/screens.dart';

import '../../api/api_manager.dart';
import '../../constants/constants.dart';
import '../../models/result_model.dart';

class HabitsDialog extends StatefulWidget {
  String userId = '',strdrinking="",streating="",strsmoking="";


  HabitsDialog(String uid, String drinking,String eating,String smoking, {Key? key}) : super(key: key)
  {
    userId = uid;
    strdrinking = drinking;
    streating = eating;
    strsmoking = smoking;
  }

  @override
  _HabitsDialogState createState() => _HabitsDialogState();
}

class _HabitsDialogState extends State<HabitsDialog> {
  String drinking = "Non-Drinking",eating="Vegetarian",smoking="Non-Smoking";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if(widget.strdrinking != null && widget.strdrinking.isNotEmpty) {
      drinking = widget.strdrinking;
    }
    if(widget.streating != null && widget.streating.isNotEmpty) {
      eating = widget.streating;
    }
    if(widget.strsmoking != null && widget.strsmoking.isNotEmpty) {
      smoking = widget.strsmoking;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      insetPadding: EdgeInsets.all(5),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isLoading ? Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ) : Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text('Habits',style: primaryColor18BoldTextStyle,textAlign: TextAlign.center),
              ),
              Column(
                children: [
                  drinkingDropdown(),
                  heightSpace,
                  heightSpace,
                  eatingDropdown(),
                  heightSpace,
                  heightSpace,
                  smokingDropdown(),
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
                  heightSpace
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  drinkingDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drinking',
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
                'Non-Drinking',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: drinking,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  drinking = newValue!;
                });
              },
              items: <String>[
                'Non-Drinking',
                'Drinking',
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

  eatingDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eating',
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
                'Vegetarian',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: eating,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  eating = newValue!;
                });
              },
              items: <String>[
                'Vegetarian',
                'Non-vegetarian',
                'Flexitarian'
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

  smokingDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smoking',
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
                'Non-Smoking',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: smoking,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  smoking = newValue!;
                });
              },
              items: <String>[
                'Non-Smoking',
                'Smoking',
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

    try {
      final ResultModel resultModel = await API_Manager.UpdateUserHabits(widget.userId, drinking,eating,smoking);

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_me/models/profile_model.dart';
import 'package:meet_me/pages/screens.dart';

import '../../api/api_manager.dart';
import '../../constants/constants.dart';
import '../../models/result_model.dart';

class FamilyDialog extends StatefulWidget {
  String userId = '';
  List<Family> _familyList = <Family>[];

  FamilyDialog(String uid, List<Family> familyList, {Key? key})
      : super(key: key) {
    userId = uid;
    _familyList = familyList;
  }

  @override
  _FamilyDialogState createState() => _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog> {
  String relation = "Father", name = "";
  TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

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
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        heightSpace,
                        heightSpace,
                        if (widget._familyList.length > 0) familyContainer(),
                        if (widget._familyList.length > 0) heightSpace,
                        if (widget._familyList.length > 0) heightSpace,
                        Text('Add New',
                            style: primaryColor16BoldTextStyle,
                            textAlign: TextAlign.center),
                        if (widget._familyList.length > 0) heightSpace,
                        if (widget._familyList.length > 0) heightSpace,
                        relationDropdown(),
                        heightSpace,
                        heightSpace,
                        nameTextField(),
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

  familyContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'My Family',
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
            child: list()),
      ],
    );
  }

  list() {
    return Wrap(
        spacing: 8,
        children: widget._familyList
            .map(
              (e) => Chip(
                label: Text(
                  e.relation + ": " + e.name,
                  style: white13SemiBoldTextStyle,
                ),
                backgroundColor: primaryColor,
                deleteIcon: Icon(
                  Icons.cancel,
                  color: whiteColor,
                  size: 18,
                ),
                onDeleted: () {
                  //delete data
                  removeMember(e.familyId);
                },
              ),
            )
            .toList());
  }

  relationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relation',
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
                'Father',
                style: black13RegularTextStyle,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: primaryColor,
                size: 20,
              ),
              value: relation,
              style: black13RegularTextStyle,
              onChanged: (String? newValue) {
                setState(() {
                  relation = newValue!;
                });
              },
              items: <String>['Father', 'Mother', 'Brother', 'Sister']
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
            controller: _nameController,
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
          name = _nameController.text;
          if (name.isNotEmpty) {
            updateDetails();
          } else {
            showSnackBar(context, 'Please write name of your $relation');
          }
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
      final ResultModel resultModel =
          await API_Manager.insertUserFamily(widget.userId, relation, name);

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

        showSnackBar(context, resultModel.message);

        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, resultModel.message);

        Navigator.of(context).pop();
      }
    } on Exception catch (_, e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }
  }

  Future<void> removeMember(String id) async {
    try {
      final ResultModel resultModel = await API_Manager.removeFamily(id);

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

        showSnackBar(context, resultModel.message);

        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, resultModel.message);

        Navigator.of(context).pop();
      }
    } on Exception catch (_, e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
    }
  }
}

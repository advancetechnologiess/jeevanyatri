import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_me/models/profile_model.dart';
import 'package:meet_me/pages/screens.dart';

import '../../api/api_manager.dart';
import '../../constants/constants.dart';
import '../../models/result_model.dart';

class HobbiesDialog extends StatefulWidget {
  String userId = '';
  List<Hobby> _hobbyList = <Hobby>[];

  HobbiesDialog(String uid, List<Hobby> hobbyList, {Key? key}) : super(key: key)
  {
    userId = uid;
    _hobbyList = hobbyList;
  }

  @override
  _HobbiesDialogState createState() => _HobbiesDialogState();
}

class _HobbiesDialogState extends State<HobbiesDialog> {
  String hobby = "";
  bool _isLoading = false;
  TextEditingController _hobbyController = TextEditingController();

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
              // Container(
              //   margin: EdgeInsets.all(5.0),
              //   child: Text('Hobbies',style: primaryColor18BoldTextStyle,textAlign: TextAlign.center),
              // ),
              Column(
                children: [
                  heightSpace,
                  heightSpace,
                  if (widget._hobbyList.length > 0) hobbyContainer(),
                  if (widget._hobbyList.length > 0) heightSpace,
                  if (widget._hobbyList.length > 0) heightSpace,
                  Text('Add New',style: primaryColor16BoldTextStyle,textAlign: TextAlign.center),
                  if (widget._hobbyList.length > 0) heightSpace,
                  if (widget._hobbyList.length > 0) heightSpace,
                  hobbyTextField(),
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

  hobbyContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'My Hobbies',
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
            child: list()
        ),
      ],
    );
  }

  list()
  {
    return Wrap(
        spacing: 8,
        children: widget._hobbyList
            .map(
              (e) => Chip(
            label: Text(e.hobby,style: white13SemiBoldTextStyle,),
            backgroundColor: primaryColor,
            deleteIcon: Icon(Icons.cancel,color: whiteColor,size: 18,),
            onDeleted: (){
              //delete data
              removeHobby(e.hobbyId);
            },),
        )
            .toList());
  }

  hobbyTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hobby',
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
            controller: _hobbyController,
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
          hobby = _hobbyController.text;
          if(hobby.isNotEmpty) {
            updateDetails();
          }
          else{
            Navigator.of(context).pop();
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
      final ResultModel resultModel = await API_Manager.insertUserHobbies(widget.userId,hobby);

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

  Future<void> removeHobby(String id) async {

    try {
      final ResultModel resultModel = await API_Manager.removeHobby(id);

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

import 'dart:convert';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meet_me/helpers/intentutils.dart';
import 'package:meet_me/models/educations_model.dart';
import 'package:meet_me/models/user_model.dart';
import 'package:meet_me/pages/auth/otp_dialog.dart';
import 'package:meet_me/pages/crop_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_manager.dart';
import '../../constants/prefs.dart';
import '../../helpers/connection_utils.dart';
import '../../models/login_model.dart';
import '../../models/result_model.dart';
import '../../models/subscription_model.dart';
import '../screens.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

class MultiPageProvider extends StatefulWidget {
  const MultiPageProvider({Key? key}) : super(key: key);

  @override
  State<MultiPageProvider> createState() => _MultiPageProviderState();
}

class _MultiPageProviderState extends State<MultiPageProvider> {
  int activeIndex = 0;
  int totalIndex = 2;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      create: (context) => UserModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
          ),
          title: Text(
            'Sign Up',
            style: primaryColor16BoldTextStyle.copyWith(fontSize: 20),
          ),
        ),
        body: Consumer<UserModel>(
          builder: (context, modal, child) {
            switch (modal.activeIndex) {
              case 0:
                return const BasicDetails();
              case 1:
                return const AddProfessionalDetails();
              case 2:
                return const AddPreference();
              default:
                return const BasicDetails();
            }
          },
        ),
      ),
    );
  }
}

class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String verificationIdReceived = "";
  String img64 = "", imagename = "";
  Io.File? _file;
  Io.File? _sample;
  Io.File? _lastCropped;

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, modal, child) {
      return Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotRadius: 10.0,
                shape: Shape.stadium,
                spacing: 10.0,
                dotCount: modal.totalIndex,
                fixedDotDecoration: const FixedDotDecoration(
                  color: primaryColor,
                ),
                indicatorDecoration: const IndicatorDecoration(
                    color: whiteColor,
                    strokeColor: primaryColor,
                    strokeWidth: 3),
              ),
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            Center(
              child: Text(
                'Step ${modal.activeIndex + 1} of ${modal.totalIndex}',
                style: primaryColor16BoldTextStyle,
              ),
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            Text(
              'Add your basic info to register your account',
              textAlign: TextAlign.center,
              style: white13RegularTextStyle.copyWith(
                  color: redColor, fontFamily: 'roboto'),
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nameTextField(),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      emailTextField(),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      mobileNumberTextField(),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      Text(
                        'Add Your Photo',
                        style: black14SemiBoldTextStyle,
                      ),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //check file access permission
                              checkPermission("gallery");
                            },
                            child: img64.isNotEmpty
                                ? CircleAvatar(
                                    // borderRadius: BorderRadius.circular(5),
                                    radius: 50,
                                    backgroundImage:
                                        Image.file(Io.File(_lastCropped!.path))
                                            .image,
                                  )
                                : Container(
                                    height: 70,
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 2.0),
                                          color: greyColor.withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/icons/profile.png',
                                      color: greyColor,
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                          ),
                          InkWell(
                            onTap: () {
                              //check file access permission
                              checkPermission("gallery");
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xfff1f8e9),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 2.0),
                                    color: greyColor.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_library_rounded,
                                    color: blackColor,
                                    size: 30,
                                  ),
                                  Text(
                                    'Gallery',
                                    style: black11SemiBoldTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //check file access permission
                              checkPermission("CAMERA");
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xffe0f2f1),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 2.0),
                                    color: greyColor.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_camera,
                                    color: blackColor,
                                    size: 30,
                                  ),
                                  Text(
                                    'Take Photo',
                                    style: black11SemiBoldTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      bioTextField(),
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      heightSpace,
                      signupButton(context, modal),
                      heightSpace,
                      heightSpace
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  bioTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: black15BoldTextStyle,
        ),
        heightSpace,
        Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.symmetric(
            horizontal: fixPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: greyColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: _bioController,
            cursorColor: primaryColor,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              hintText:
                  'Write something about yourself, you can change this later on as well',
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator:(value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please write few words about you';
            //   }
            //   return null;
            // }
          ),
        ),
      ],
    );
  }

  checkPermission(String calledFor) async {
    final status = await Permission.storage.request();
    // final status2 = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted.');
      _pickImage(calledFor);
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
      await Permission.storage.shouldShowRequestRationale;
    }
  }

  void _pickImage(String calledFor) async {
    try {
      var pickedFile;
      if (calledFor == "CAMERA") {
        pickedFile = await _picker.getImage(source: ImageSource.camera);
      } else {
        pickedFile = await _picker.getImage(source: ImageSource.gallery);
      }

      final file = Io.File(pickedFile!.path);

      final sample = await ImageCrop.sampleImage(
        file: file,
        preferredSize: context.size!.longestSide.ceil(),
      );

      _sample?.delete();
      _file?.delete();

      setState(() {
        _imageFile = pickedFile!;

        _sample = sample;
        _file = file;

        // final bytes = Io.File(_imageFile.path).readAsBytesSync();
        // Uri uri = Uri.file(_imageFile.path);
        // String strextension = uri.pathSegments.last.split(".").last;
        //
        // imagename = DateTime.now().millisecondsSinceEpoch.toString()+"_prImg.$strextension";
        //
        // img64 = base64Encode(bytes);
        //
        // print('strusrimage: '+imagename);

        //update image
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

    if (results != null && results.containsKey('img64')) {
      setState(() {
        img64 = results['img64'];
        imagename = DateTime.now().millisecondsSinceEpoch.toString() +
            "_prImg.${results['strextension']}";
        _lastCropped = results['_lastCropped'];
      });
    }
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
          child: TextFormField(
            controller: _nameController,
            cursorColor: primaryColor,
            style: black13MediumTextStyle,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EmailId',
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
          child: TextFormField(
              controller: _emailController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              }),
        ),
      ],
    );
  }

  mobileNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
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
          child: TextFormField(
              controller: _mobileController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                counterText: "",
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              }),
        ),
      ],
    );
  }

  signupButton(context, UserModel modal) {
    return InkWell(
      onTap: () => {
        if (_formKey.currentState!.validate())
          {
            modal.name =
                _nameController.text, //calling custom setter to set value
            modal.email = _emailController.text,
            modal.mobileNo = _mobileController.text,
            modal.bio = _bioController.text,
            modal.image64 = img64,
            modal.imageName = imagename,
            //open popup for otp

            checkIfAccountExist(context, modal)
            // modal.changeIndex(modal.activeIndex+1)
          }
      },
      child: Container(
        padding: const EdgeInsets.all(fixPadding * 1.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: whiteColor,
                ),
              )
            : Text(
                'Sign Up'.toUpperCase(),
                style: white16BoldTextStyle,
              ),
      ),
    );
  }

  checkIfAccountExist(context, UserModel modal) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final LoginModel resultModel =
              await API_Manager.contactExist(modal.mobileNo);

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context,
                "There is already one account exist with this mobile number");
          } else {
            setState(() {
              _isLoading = false;
            });

            sendVerificationCode(context, modal);
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

  sendVerificationCode(BuildContext context, UserModel modal) {
    setState(() {
      _isLoading = true;
    });
    auth.verifyPhoneNumber(
        phoneNumber: '+91' + _mobileController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) => {
                showSnackBar(context, "Verification Completed"),
                //print("You are login Successfully"),
                setState(() {
                  _isLoading = false;
                }),

                Navigator.of(context).pop(),
                modal.changeIndex(1)
              });
        },
        verificationFailed: (FirebaseAuthException exception) {
          showSnackBar(context, exception.toString());
          print(exception.message);
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          showSnackBar(context, "Verification Code sent on the phone number");

          setState(() {
            _isLoading = false;
            verificationIdReceived = verificationId;
          });

          debugPrint('verificationId :' + verificationId);

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return OTPDialog(
                    verificationIdReceived: verificationIdReceived);
              }).then((value) {
            if (value.toString() == 'success') {
              modal.changeIndex(1);
            } else {
              showSnackBar(context, 'Verification Failed');
            }
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackBar(context, "Time Out");
          setState(() {
            _isLoading = false;
          });
        });
  }
}

class AddProfessionalDetails extends StatefulWidget {
  const AddProfessionalDetails({Key? key}) : super(key: key);

  @override
  State<AddProfessionalDetails> createState() => _AddProfessionalDetailsState();
}

class _AddProfessionalDetailsState extends State<AddProfessionalDetails> {
  final _formKey = GlobalKey<FormState>();
  String? gender = "Male";
  String strExprirationDate = "";
  TextEditingController _dobController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  // TextEditingController _incomeController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _castController = TextEditingController();
  List<Education> _educationList = <Education>[];
  Education? _selectedEducation;

  String caste = 'Gujarati Patel', income = '';
  String? strheight,
      education,
      job_in,
      degree,
      mStatus,
      religion,
      country,
      state,
      occupation,
      mothertounge,
      city;
  bool isManglik = false,
      isNRI = false,
      isCountryError = false,
      isStatesError = false,
      isCityError = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    income = incomeArray.first;
    fetchFreePlan();
    fetchEducationsList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, modal, child) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
              children: [
                Center(
                  child: DotStepper(
                    activeStep: modal.activeIndex,
                    dotRadius: 10.0,
                    shape: Shape.stadium,
                    spacing: 10.0,
                    dotCount: modal.totalIndex,
                    fixedDotDecoration: const FixedDotDecoration(
                      color: primaryColor,
                    ),
                    indicatorDecoration: const IndicatorDecoration(
                        color: whiteColor,
                        strokeColor: primaryColor,
                        strokeWidth: 3),
                  ),
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                Center(
                  child: Text(
                    'Step ${modal.activeIndex + 1} of ${modal.totalIndex}',
                    style: primaryColor16BoldTextStyle,
                  ),
                ),
                heightSpace,
                heightSpace,
                Text(
                  'Add some more of your information, it will help us\nto find a better match for you',
                  textAlign: TextAlign.center,
                  style: white13RegularTextStyle.copyWith(
                      color: redColor, fontFamily: 'roboto'),
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    dobTextField(modal),
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
                    incomeTextField(),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  children: [
                    occupationTextfield(),
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
                //
                //       widthSpace,
                //       widthSpace,
                //       castDropdown(), //castTextField(),
                //     ],
                //   ),
                // ),
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
                stateTextField(),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 5,
                              child: InkWell(
                                onTap: () =>
                                    {confirmationDialog(context, modal)},
                                child: Container(
                                  height: 45,
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Previous',
                                    style: white16BoldTextStyle,
                                  ),
                                ),
                              ),
                            ),
                            widthSpace,
                            widthSpace,
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: const VerticalDivider(
                                  thickness: 2,
                                  width: 2,
                                  color: whiteColor,
                                )),
                            widthSpace,
                            widthSpace,
                            Flexible(
                              flex: 5,
                              child: InkWell(
                                onTap: () => {
                                  debugPrint('NAME : ${modal.name}'),
                                  if (_formKey.currentState!.validate())
                                    {
                                      modal.dob = _dobController.text,
                                      modal.age = (modal.calculateAge(
                                              _dobController.text))
                                          .toString(),
                                      modal.gender = (gender ?? 'Male'),
                                      modal.Height = (strheight ?? ""),
                                      modal.weight = _weightController.text,
                                      modal.education = (degree == "Graduate"
                                          ? education
                                          : _educationController.text)!,
                                      modal.empIn = (job_in ?? ''),
                                      modal.annualIncome = income,
                                      modal.qualification = (degree ?? ""),
                                      modal.occupation = (occupation ?? ""),
                                      modal.maritalStatus =
                                          (mStatus ?? 'Single'),
                                      modal.mothertounge = (mothertounge ?? ""),
                                      modal.pincode = _pincodeController.text,
                                      modal.religion = (religion ?? ""),
                                      // modal.cast = _castController.text,
                                      modal.cast = caste,
                                      modal.isManglik = isManglik,
                                      modal.isNRI = isNRI,

                                      if (country != null &&
                                          country!.isNotEmpty)
                                        {
                                          modal.country = country!,
                                          modal.state = state!,
                                          modal.city = city!,
                                          insertNewUser(context, modal)
                                        }
                                      else
                                        {
                                          setState(() {
                                            isCountryError = true;
                                          })
                                        }
                                    }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Next',
                                    style: white16BoldTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                heightSpace,
                heightSpace
              ],
            ),
          )
        ],
      );
    });
  }

  dobTextField(UserModel modal) {
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
            child: TextFormField(
              controller: _dobController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter birth date';
                } else if (!modal.isAdult(value)) {
                  return 'Your age should be minimum 18';
                } else {
                  return null;
                }
              },
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

  _age() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            textAlign: TextAlign.left,
            style: black13RegularTextStyle,
          ),
        ),
      ],
    );
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
              child: DropdownButton(
                isExpanded: true,
                elevation: 4,
                isDense: true,
                hint: Text(
                  'Select gender',
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
            child: TextFormField(
              controller: _weightController,
              cursorColor: primaryColor,
              style: black13MediumTextStyle,
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  counterText: ""
                  // helperText: 'e.g 50 kg'
                  ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 3,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                } else
                  return null;
              },
            ),
          ),
        ],
      ),
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
          border: UnderlineInputBorder(borderSide: BorderSide.none),
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
                    return 'Please select qualification';
                  } else
                    return null;
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
                  'Select',
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
                items:
                    incomeArray.map<DropdownMenuItem<String>>((String value) {
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

  occupationTextfield() {
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
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                elevation: 4,
                isDense: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Please select Occupation';
                  } else {
                    return null;
                  }
                },
                hint: Text(
                  'select occupation',
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
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                elevation: 4,
                isDense: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Select Maritial Status';
                  } else {
                    return null;
                  }
                },
                hint: Text(
                  'status',
                  style: black13RegularTextStyle,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 20,
                ),
                value: mStatus,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    mStatus = newValue;
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
                value: caste,
                style: black13RegularTextStyle,
                onChanged: (String? newValue) {
                  setState(() {
                    caste = newValue!;
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
                "Assamese",
                "Bangla",
                "Bodo",
                "Dogri",
                "Gujarati",
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

  castTextField() {
    return Expanded(
      flex: 4,
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
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your cast';
                } else {
                  return null;
                }
              },
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
                'Are you Manglik',
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

  stateTextField() {
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
          disabledDropdownDecoration: isCountryError
              ? BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                  border: Border.all(color: Colors.red, width: 1))
              : BoxDecoration(
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
            setState(() {
              ///store value in country variable
              country = value;
            });
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

  //confirm to go on previous page
  confirmationDialog(context, UserModel modal) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(fixPadding * 1.5),
                child: Column(
                  children: [
                    Text(
                      'Are you sure you want to go to previous page?',
                      style: black16SemiBoldTextStyle,
                    ),
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    heightSpace,
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'No',
                                style: primaryColor16BoldTextStyle,
                              ),
                            ),
                          ),
                        ),
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        widthSpace,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              modal.changeIndex(modal.activeIndex - 1);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Yes',
                                style: white16BoldTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> insertNewUser(context, UserModel model) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print("strphone: "+strphone);
          LoginModel resultModel;
          if (model.image64.isNotEmpty) {
            resultModel = await API_Manager.insertUserWithImage(
              model.name,
              model.mobileNo,
              model.email,
              model.age,
              model.gender,
              model.Height,
              model.weight,
              model.dob,
              model.maritalStatus,
              model.isManglik.toString(),
              model.isNRI.toString(),
              model.religion,
              model.cast,
              "",
              model.image64,
              model.imageName,
              model.bio,
              model.city,
              model.state,
              model.country,
              strExprirationDate,
              model.qualification,
              model.education,
              model.occupation,
              model.empIn,
              model.annualIncome,
              model.mothertounge,
              model.pincode,
            );
          } else {
            resultModel = await API_Manager.insertUser(
              model.name,
              model.mobileNo,
              model.email,
              model.age,
              model.gender,
              model.Height,
              model.weight,
              model.dob,
              model.maritalStatus,
              model.isManglik.toString(),
              model.isNRI.toString(),
              model.religion,
              model.cast,
              "",
              model.bio,
              model.city,
              model.state,
              model.country,
              strExprirationDate,
              model.qualification,
              model.education,
              model.occupation,
              model.empIn,
              model.annualIncome,
              model.mothertounge,
              model.pincode,
            );
          }

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            model.userId = resultModel.login.first.id.toString();
            model.changeIndex(2);
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

  Future<void> fetchFreePlan() async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          final SubscriptionPlansModel subscriptionPlan =
              await API_Manager.fetchSubscriptionPlans();

          if (subscriptionPlan.error != true) {
            for (int i = 0;
                i < subscriptionPlan.subscriptionPlans.length;
                i++) {
              if (subscriptionPlan.subscriptionPlans
                      .elementAt(i)
                      .name
                      .toLowerCase() ==
                  "free") {
                var today = new DateTime.now();
                String strdays =
                    subscriptionPlan.subscriptionPlans.elementAt(i).validity;
                var daysFromNow =
                    today.add(new Duration(days: int.parse(strdays)));
                final DateFormat formatter = DateFormat('dd/MM/yyyy');

                setState(() {
                  strExprirationDate = formatter.format(daysFromNow);
                });
              }
            }

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
            setState(() {
              _isLoading = false;
              _educationList = educationModel.educations;
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
}

class AddPreference extends StatefulWidget {
  const AddPreference({Key? key}) : super(key: key);

  @override
  State<AddPreference> createState() => _AddPreferenceState();
}

class _AddPreferenceState extends State<AddPreference> {
  String? ageFrom;
  String? ageTo;
  String? heightFrom;
  String? heightTo;
  String? caste;
  String? country, state, city, degree, education, religion = 'Hindu';
  bool isManglik = false,
      isNRI = false,
      isCountryError = false,
      isStatesError = false,
      isCityError = false;

  bool _isLoading = false;
  TextEditingController _educationController = TextEditingController();
  var prefCastArray = <String>[];
  var prefQulfnArray = <String>[];

  List<Education> _educationList = <Education>[];
  Education? _selectedEducation;

  final _formKey = GlobalKey<FormState>();
  String income = "";

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
    fetchEducationsList();
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
            setState(() {
              _isLoading = false;
              _educationList = educationModel.educations;
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
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, modal, child) {
      return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          children: [
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotRadius: 10.0,
                shape: Shape.stadium,
                spacing: 10.0,
                dotCount: modal.totalIndex,
                fixedDotDecoration: const FixedDotDecoration(
                  color: primaryColor,
                ),
                indicatorDecoration: const IndicatorDecoration(
                    color: whiteColor,
                    strokeColor: primaryColor,
                    strokeWidth: 3),
              ),
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            Center(
              child: Text(
                'Step ${modal.activeIndex + 1} of ${modal.totalIndex}',
                style: primaryColor16BoldTextStyle,
              ),
            ),
            heightSpace,
            heightSpace,
            Text(
              'Add your preference to help us finding you a best partner',
              textAlign: TextAlign.center,
              style: white13RegularTextStyle.copyWith(
                  color: redColor, fontFamily: 'roboto'),
            ),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            age(),
            heightSpace,
            heightSpace,
            heightSpace,
            heightSpace,
            height(),
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
            //     castTextField(),
            //   ],
            // ),
            // heightSpace,
            // heightSpace,
            // heightSpace,
            // heightSpace,
            Row(
              children: [
                manglikField(),
                widthSpace,
                widthSpace,
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
            heightSpace,
            heightSpace,
            Container(
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: whiteColor,
                        ),
                      )
                    : InkWell(
                        onTap: () => {
                          if (_formKey.currentState!.validate())
                            {
                              modal.partnerMaxAge = (ageTo ?? ""),
                              modal.partnerMinAge = (ageFrom ?? ""),
                              modal.partnerMaxHeight = (heightTo ?? ""),
                              modal.partnerMinHeight = (heightFrom ?? ""),
                              modal.partnerReligion = 'Hindu',
                              modal.partnerCast = caste!,
                              modal.partnerqul = (degree ?? ""),
                              modal.partnerEdu = (degree == "Graduate"
                                  ? education
                                  : _educationController.text)!,
                              modal.prefIsManglik = isManglik,
                              modal.prefCity = (city ?? ""),
                              modal.prefState = (state ?? ""),
                              modal.prefCountry = (country ?? ""),
                              modal.prefIncome = income,
                              updateDetails(modal)
                            }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Submit',
                            style: white16BoldTextStyle,
                          ),
                        ),
                      ) //buttonView(modal),
                ),
            heightSpace,
            heightSpace
          ],
        ),
      );
    });
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

  buttonView(UserModel modal) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: InkWell(
            onTap: () => {modal.changeIndex(modal.activeIndex - 1)},
            child: Container(
              height: 45,
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Previous',
                style: white16BoldTextStyle,
              ),
            ),
          ),
        ),
        widthSpace,
        widthSpace,
        Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: const VerticalDivider(
              thickness: 2,
              width: 2,
              color: whiteColor,
            )),
        widthSpace,
        widthSpace,
        Flexible(
          flex: 5,
          child: InkWell(
            onTap: () => {
              if (_formKey.currentState!.validate())
                {
                  modal.partnerMaxAge = (ageTo ?? ""),
                  modal.partnerMinAge = (ageFrom ?? ""),
                  modal.partnerMaxHeight = (heightTo ?? ""),
                  modal.partnerMinHeight = (heightFrom ?? ""),
                  modal.partnerReligion = 'Hindu',
                  modal.partnerCast = caste!,
                  modal.partnerqul = (degree ?? ""),
                  modal.partnerEdu = (degree == "Graduate"
                      ? education
                      : _educationController.text)!,
                  modal.prefIsManglik = isManglik,
                  modal.prefCity = (city ?? ""),
                  modal.prefState = (state ?? ""),
                  modal.prefCountry = (country ?? ""),
                  modal.prefIncome = income,
                  updateDetails(modal)
                }
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Submit',
                style: white16BoldTextStyle,
              ),
            ),
          ),
        ),
      ],
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

  height() {
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
              child: DropdownButtonFormField(
                decoration: const InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                elevation: 4,
                isDense: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value == "") {
                    return 'Select religion';
                  } else {
                    return null;
                  }
                },
                hint: Text(
                  'Religion',
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
      ],
    );
  }

  Future<void> updateDetails(UserModel model) async {
    ConnectionUtils.checkConnection().then((intenet) async {
      if (intenet != null && intenet) {
        try {
          setState(() {
            _isLoading = true;
          });

          // print(strphone +" "+strpass);
          final ResultModel resultModel =
              await API_Manager.updatePartnerPrefrence(
                  model.userId,
                  model.partnerMinAge,
                  model.partnerMaxAge,
                  model.partnerMinHeight,
                  model.partnerMaxHeight,
                  model.partnerqul,
                  model.partnerEdu,
                  "",
                  model.isManglik.toString(),
                  model.isNRI.toString(),
                  model.partnerReligion,
                  model.partnerCast,
                  "",
                  model.prefCity,
                  model.state,
                  model.country,
                  income);

          if (resultModel.error != true) {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(context, resultModel.message);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(Prefs.isLoggedIn, true);
            prefs.setString(Prefs.USER_ID, model.userId);
            print("id: " + model.userId);
            IntentUtils.fireIntent(context, const BottomBar());
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
}

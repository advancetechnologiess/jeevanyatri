import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _mobileNo;
  String? _image64;
  String? _imageName;
  String? _bio;
  String? _dob;
  String? _age;
  String? _gender;
  String? _Height;
  String? _weight;
  String? _education;
  String? _qualification;
  String? _empIn;
  String? _annualIncome;
  String? _occupation;
  String? _maritalStatus;
  String? _religion;
  String? _cast;
  String? _mothertounge;
  String? _pincode;
  bool _isManglik = false;
  bool _isNRI = false;

  String get mothertounge => _mothertounge ?? "";

  set mothertounge(String value) {
    _mothertounge = value;
  }

  String get pincode => _pincode ?? "";

  set pincode(String value) {
    _pincode = value;
  }

  bool get isNRI => _isNRI;

  set isNRI(bool value) {
    _isNRI = value;
  }

  String? _country;
  String? _state;
  String? _city;

  String _userId = "";

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String? _partnerMinAge;
  String? _partnerMaxAge;
  String? _partnerMinHeight;
  String? _partnerMaxHeight;
  String? _partnerEdu;
  String? _partnerqul;
  String? _partnerReligion;
  String? _partnerCast;
  bool _prefIsManglik = false;
  String? _prefCountry;
  String? _prefState;
  String? _prefCity;
  String? _prefIncome;

  String get prefIncome => _prefIncome ?? "";

  set prefIncome(String value) {
    _prefIncome = value;
  }

  int activeIndex = 0;
  int totalIndex = 3;

  changeIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }

  String get name => _name ?? "";

  set name(String value) {
    _name = value;
  }

  String get prefCity => _prefCity ?? "";

  set prefCity(String value) {
    _prefCity = value;
  }

  String get prefState => _prefState ?? "";

  set prefState(String value) {
    _prefState = value;
  }

  String get prefCountry => _prefCountry ?? "";

  set prefCountry(String value) {
    _prefCountry = value;
  }

  bool get prefIsManglik => _prefIsManglik;

  set prefIsManglik(bool value) {
    _prefIsManglik = value;
  }

  String get partnerCast => _partnerCast ?? "";

  set partnerCast(String value) {
    _partnerCast = value;
  }

  String get partnerReligion => _partnerReligion ?? "";

  set partnerReligion(String value) {
    _partnerReligion = value;
  }

  String get partnerEdu => _partnerEdu ?? "";

  set partnerEdu(String value) {
    _partnerEdu = value;
  }

  String get partnerMaxHeight => _partnerMaxHeight ?? "";

  set partnerMaxHeight(String value) {
    _partnerMaxHeight = value;
  }

  String get partnerMinHeight => _partnerMinHeight ?? "";

  set partnerMinHeight(String value) {
    _partnerMinHeight = value;
  }

  String get partnerMaxAge => _partnerMaxAge ?? "";

  set partnerMaxAge(String value) {
    _partnerMaxAge = value;
  }

  String get partnerMinAge => _partnerMinAge ?? "";

  set partnerMinAge(String value) {
    _partnerMinAge = value;
  }

  String get city => _city ?? "";

  set city(String value) {
    _city = value;
  }

  String get state => _state ?? "";

  set state(String value) {
    _state = value;
  }

  String get country => _country ?? "";

  set country(String value) {
    _country = value;
  }

  bool get isManglik => _isManglik;

  set isManglik(bool value) {
    _isManglik = value;
  }

  String get cast => _cast ?? "";

  set cast(String value) {
    _cast = value;
  }

  String get religion => _religion ?? "";

  set religion(String value) {
    _religion = value;
  }

  String get maritalStatus => _maritalStatus ?? "";

  set maritalStatus(String value) {
    _maritalStatus = value;
  }

  String get occupation => _occupation ?? "";

  set occupation(String value) {
    _occupation = value;
  }

  String get annualIncome => _annualIncome ?? "";

  set annualIncome(String value) {
    _annualIncome = value;
  }

  String get empIn => _empIn ?? "";

  set empIn(String value) {
    _empIn = value;
  }

  String get education => _education ?? "";

  set education(String value) {
    _education = value;
  }

  String get weight => _weight ?? "";

  set weight(String value) {
    _weight = value;
  }

  String get Height => _Height ?? "";

  set Height(String value) {
    _Height = value;
  }

  String get gender => _gender ?? "";

  set gender(String value) {
    _gender = value;
  }

  String get dob => _dob ?? "";

  set dob(String value) {
    _dob = value;
  }

  String get bio => _bio ?? "";

  set bio(String value) {
    _bio = value;
  }

  String get imageName => _imageName ?? "";

  set imageName(String value) {
    _imageName = value;
  }

  String get image64 => _image64 ?? "";

  set image64(String value) {
    _image64 = value;
  }

  String get mobileNo => _mobileNo ?? "";

  set mobileNo(String value) {
    _mobileNo = value;
  }

  String get email => _email ?? "";

  set email(String value) {
    _email = value;
  }

  String get qualification => _qualification ?? "";

  set qualification(String value) {
    _qualification = value;
  }

  String get partnerqul => _partnerqul ?? "";

  set partnerqul(String value) {
    _partnerqul = value;
  }

  String get age => _age ?? "";

  set age(String value) {
    _age = value;
  }

  bool isAdult(String birthDateString) {
    String datePattern = "dd MMM yyyy";

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
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

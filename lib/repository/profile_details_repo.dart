import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/personal_information_model.dart';

class ProfileRepo {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String userId = FirebaseAuth.instance.currentUser!.uid;


  Future<PersonalInformationModel> getDetails() async {
    PersonalInformationModel personalInfo = PersonalInformationModel(
        companyName: 'Loading...',
        businessCategory: 'Loading...',
        countryName: 'Loading...',
        language: 'Loading...',
        phoneNumber: 'Loading...',
        pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png');
    final model = await ref.child('$userId/Personal Information').get();
    var data = jsonDecode(jsonEncode(model.value));
    if (data == null) {
      return personalInfo;
    } else {
      return PersonalInformationModel.fromJson(data);
    }
  }
}

// final profileDetailsRepo = ChangeNotifierProvider((ref) => ProfileDetailsRepo());
//
// class ProfileDetailsRepo extends ChangeNotifier {
//   DatabaseReference ref = FirebaseDatabase.instance.ref();
//
//   ProfileDetailsModel profileDetailsModel = ProfileDetailsModel(
//       companyName: 'Loading...',
//       businessCategory: 'Loading...',
//       countryName: 'Loading...',
//       language: 'Loading...',
//       phoneNumber: 'Loading...',
//       pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png');
//
//   void getProfileDetails() async {
//     final name = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/companyName').get();
//     final category =
//         await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/businessCategory').get();
//     final phone = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/phoneNumber').get();
//     final picture = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/pictureUrl').get();
//     var lan = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/language').get();
//     final country = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/countryName').get();
//     final model = await ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information').get();
//
//     profileDetailsModel.companyName = name.value.toString();
//     profileDetailsModel.businessCategory = category.value.toString();
//     profileDetailsModel.language = lan.value.toString();
//     profileDetailsModel.countryName = country.value.toString();
//     profileDetailsModel.phoneNumber = phone.value.toString();
//     profileDetailsModel.pictureUrl = picture.value.toString();
//
//     var datas = jsonDecode(jsonEncode(model.value));
//     var da = PersonalInformationModel.fromJson(datas);
//     var g = PersonalInformationModel(
//         companyName: 'Loading...',
//         businessCategory: 'Loading...',
//         countryName: 'Loading...',
//         language: 'Loading...',
//         phoneNumber: 'Loading...',
//         pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png'
//     );
//     print(g.toJson());
//     notifyListeners();
//   }
// }
//
// class ProfileDetailsModel {
//   ProfileDetailsModel({
//     required this.companyName,
//     required this.businessCategory,
//     required this.phoneNumber,
//     required this.countryName,
//     required this.pictureUrl,
//     required this.language,
//   });
//   String language;
//   String businessCategory;
//   String companyName;
//   String phoneNumber;
//   String countryName;
//   String pictureUrl;
// }
//
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// //
// // final profileDetailsRepo = ChangeNotifierProvider((ref) => ProfileDetailsRepo());
// //
// // class ProfileDetailsRepo extends ChangeNotifier {
// //   DatabaseReference ref = FirebaseDatabase.instance.ref();
// //
// //   Future<ProfileDetailsModel> getProfileDetails() async {
// //     ProfileDetailsModel profileDetailsModel =
// //     ProfileDetailsModel('companyName', 'businessCategory', 'phoneNumber', 'countryName', 'pictureUrl', 'language');
// //     final dta = await
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/companyName').get();
// //     profileDetailsModel.businessCategory =
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/businessCategory').get().toString();
// //     profileDetailsModel.phoneNumber =
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/phoneNumber').get().toString();
// //     profileDetailsModel.pictureUrl =
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/pictureUrl').get().toString();
// //     profileDetailsModel.language =
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/language').get().toString();
// //     profileDetailsModel.countryName =
// //         ref.child('${FirebaseAuth.instance.currentUser!.uid}/Personal Information/countryName').get().toString();
// //
// //     notifyListeners();
// //     return profileDetailsModel;
// //   }
// // }
// //

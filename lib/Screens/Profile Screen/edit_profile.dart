import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Models/personal_information.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../model/personal_information_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String dropdownLangValue = 'English';
  String initialCountry = 'भारत';
  String dropdownValue = 'Client';
  String companyName = 'nodata', phoneNumber = 'nodata';
  double progress = 0.0;
  bool showProgress = false;
  String profilePicture = 'nodata';
  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  final ImagePicker _picker = ImagePicker();
  late final XFile? pickedImage;
  late final XFile? pickedCameraImage;

  int loopCount = 0;

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );

      var snapshot =
          await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      EasyLoading.showSuccess('Upload Successful!');
      setState(() {
        profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  DropdownButton<String> getCategory(String category) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String category in businessCategory) {
      var item = DropdownMenuItem(
        value: category,
        child: Text(category),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: category,
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }

  DropdownButton<String> getLanguage(String lang) {
    List<DropdownMenuItem<String>> dropDownLangItems = [];
    for (String lang in language) {
      var item = DropdownMenuItem(
        value: lang,
        child: Text(lang),
      );
      dropDownLangItems.add(item);
    }
    return DropdownButton(
      items: dropDownLangItems,
      value: lang,
      onChanged: (value) {
        setState(() {
          dropdownLangValue = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Update Your Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
          loopCount++;
          if (loopCount == 1) {
            dropdownValue = userProfileDetails.value!.businessCategory.toString();
            dropdownLangValue = userProfileDetails.value!.language.toString();
          }
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Update your profile to connect with person with better impression",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: const Image(
                      image: AssetImage('images/propic.png'),
                    ),
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          dialogContext = context;
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 200.0,
                              width: MediaQuery.of(context).size.width - 80,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                        Navigator.pop(dialogContext);
                                        uploadFile(pickedImage!.path);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.photo_library_rounded,
                                            size: 60.0,
                                            color: kMainColor,
                                          ),
                                          Text(
                                            'Gallery',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: kMainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                        Navigator.pop(dialogContext);
                                        uploadFile(pickedImage!.path);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera,
                                            size: 60.0,
                                            color: kGreyTextColor,
                                          ),
                                          Text(
                                            'Camera',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              color: kGreyTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 60.0,
                    child: FormField(
                      builder: (FormFieldState<dynamic> field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Category',
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                          child: DropdownButtonHideUnderline(child: getCategory(dropdownValue)),
                        );
                      },
                    ),
                  ),
                ),
                userProfileDetails.when(data: (details) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          initialValue: details.companyName,
                          onChanged: (value) {
                            setState(() {
                              companyName = value;
                            });
                          }, // Optional
                          textFieldType: TextFieldType.NAME,
                          decoration:
                              const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 60.0,
                          child: AppTextField(
                            textFieldType: TextFieldType.PHONE,
                            initialValue: details.phoneNumber,
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '+91-8898767778',
                              border: const OutlineInputBorder(),
                              prefix: CountryCodePicker(
                                padding: EdgeInsets.zero,
                                onChanged: print,
                                initialSelection: 'भारत',
                                showFlag: false,
                                showDropDownButton: true,
                                alignLeft: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 60.0,
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: TextEditingController(text: initialCountry),
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kGreyTextColor),
                              ),
                              labelText: 'Country',
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                              hintText: 'भारत',
                              border: const OutlineInputBorder(),
                              prefix: CountryCodePicker(
                                padding: EdgeInsets.zero,
                                onChanged: (CountryCode countrycode) {
                                  setState(() {
                                    initialCountry = countrycode.name!;
                                  });
                                },
                                initialSelection: 'भारत',
                                showOnlyCountryWhenClosed: false,
                                showFlagMain: true,
                                showCountryOnly: false,
                                showDropDownButton: true,
                                alignLeft: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 60.0,
                          child: FormField(
                            builder: (FormFieldState<dynamic> field) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'Language',
                                    labelStyle: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(child: getLanguage(dropdownLangValue)),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const CircularProgressIndicator();
                }),
                const SizedBox(
                  height: 40.0,
                ),
                ButtonGlobal(
                  iconWidget: Icons.arrow_forward,
                  buttontext: 'Continue',
                  iconColor: Colors.white,
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    if (profilePicture == 'nodata') {
                      setState(() {
                        profilePicture = userProfileDetails.value!.pictureUrl.toString();
                      });
                    }
                    if (companyName == 'nodata') {
                      setState(() {
                        companyName = userProfileDetails.value!.companyName.toString();
                      });
                    }
                    if (phoneNumber == 'nodata') {
                      setState(() {
                        phoneNumber = userProfileDetails.value!.phoneNumber.toString();
                      });
                    }
                    try {
                      EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                      // ignore: no_leading_underscores_for_local_identifiers
                      final DatabaseReference _personalInformationRef = FirebaseDatabase.instance
                          // ignore: deprecated_member_use
                          .reference()
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .child('Personal Information');
                      PersonalInformation personalInformation = PersonalInformation(
                          dropdownValue, companyName, phoneNumber, initialCountry, dropdownLangValue, profilePicture);
                      await _personalInformationRef.set(personalInformation.toJson());
                      ref.refresh(profileDetailsProvider);
                      EasyLoading.showSuccess('Updated Successfully', duration: const Duration(milliseconds: 1000));
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/home');
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                    // Navigator.pushNamed(context, '/otp');
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

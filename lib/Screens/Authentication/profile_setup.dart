import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/Models/personal_information.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  String dropdownLangValue = 'English';
  String initialCountry = 'भारत';
  String dropdownValue = 'Client';
  late String companyName, phoneNumber;
  double progress = 0.0;
  bool showProgress = false;
  String profilePicture = 'https://i.imgur.com/jlyGd1j.jpg';
  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  final ImagePicker _picker = ImagePicker();
  late final XFile? pickedImage;
  late final XFile? pickedCameraImage;
  TextEditingController controller = TextEditingController();

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(status: 'Uploading... ',dismissOnTap: false,);
      var snapshot = await FirebaseStorage.instance
          .ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      EasyLoading.showSuccess('Upload Successful!');
      setState(() {
        profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  DropdownButton<String> getCategory() {
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
      value: dropdownValue,
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }

  DropdownButton<String> getLanguage() {
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
      value: dropdownLangValue,
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
          'Setup Your Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Update your profile to connect your doctor with better impression",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                                      pickedImage = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      Navigator.pop(dialogContext);
                                      uploadFile(pickedImage!.path);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      pickedImage = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      Navigator.pop(dialogContext);
                                      uploadFile(pickedImage!.path);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            labelText: 'Business Category',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        child:
                            DropdownButtonHideUnderline(child: getCategory()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppTextField(
                  onChanged: (value){
                    setState(() {
                      companyName = value;
                    });
                  },// Optional
                  textFieldType: TextFieldType.NAME,
                  decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 60.0,
                  child: AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    onChanged: (value){
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '+918898617778',
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
                child: AppTextField(
                  // ignore: deprecated_member_use
                  textFieldType: TextFieldType.ADDRESS,
                  controller: controller,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGreyTextColor),
                    ),
                    labelText: 'Company Address',
                    hintText: 'Enter Full Address',
                    border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        child:
                            DropdownButtonHideUnderline(child: getLanguage()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              ButtonGlobal(
                iconWidget: Icons.arrow_forward,
                buttontext: 'Continue',
                iconColor: Colors.white,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () async{
                  try{
                    EasyLoading.show(status: 'Loading...',dismissOnTap: false);
                    // ignore: no_leading_underscores_for_local_identifiers
                    final DatabaseReference _personalInformationRef =
                    // ignore: deprecated_member_use
                    FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
                    PersonalInformation personalInformation =  PersonalInformation(dropdownValue, companyName, phoneNumber, controller.text, dropdownLangValue, profilePicture);
                    await _personalInformationRef.set(personalInformation.toJson());
                    EasyLoading.showSuccess('Added Successfully',duration: const Duration(milliseconds: 1000));
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                  // Navigator.pushNamed(context, '/otp');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

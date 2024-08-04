// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

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
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  String radioItem = 'Client';
  String groupValue = '';
  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  bool expanded = false;
  String customerName = 'Guest';
  String phoneNumber = '000';
  String customerAddress = 'Not Provided';
  String emailAddress = 'Not Provided';
  String dueAmount = '0';
  String profilePicture = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png';
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  double progress = 0.0;
  bool isPhoneAlready = false;
  XFile? pickedImage;
  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot =
          await FirebaseStorage.instance.ref('Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Contact',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final customerData = ref.watch(customerProvider);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Phone Number',
                      hintText: '+91-8767 432556',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        customerName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Name',
                      hintText: 'Furqan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        groupValue: groupValue,
                        title: Text(
                          'Client',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Client',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        groupValue: groupValue,
                        title: Text(
                          'Others',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Others',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: kMainColor,
                        groupValue: groupValue,
                        title: Text(
                          'Contractor',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Contractor',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: kMainColor,
                        groupValue: groupValue,
                        title: Text(
                          'Supplier',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                          ),
                        ),
                        value: 'Supplier',
                        onChanged: (value) {
                          setState(() {
                            groupValue = value.toString();
                            radioItem = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: showProgress,
                  child: const CircularProgressIndicator(
                    color: kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {},
                  animationDuration: const Duration(seconds: 1),
                  elevation: 0,
                  dividerColor: Colors.white,
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              child: Text(
                                'More Info',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  color: kMainColor,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  expanded == false ? expanded = true : expanded = false;
                                });
                              },
                            ),
                          ],
                        );
                      },
                      body: Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54, width: 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(8.00)),
                                  image: DecorationImage(
                                    image: NetworkImage(profilePicture),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
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
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
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
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
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
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1),
                                    borderRadius: const BorderRadius.all(Radius.circular(8.00)),
                                  ),
                                  child: const Center(child: Text('Change')),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.EMAIL,
                              onChanged: (value) {
                                setState(() {
                                  emailAddress = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Email Address',
                                hintText: 'furqan@gmail.com',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.NAME,
                              maxLines: 2,
                              onChanged: (value) {
                                setState(() {
                                  customerAddress = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Address',
                                  hintText: 'Andheri, Mumbai, 400104'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.PHONE,
                              onChanged: (value) {
                                setState(() {
                                  dueAmount = value;
                                });
                              },
                              maxLines: 2,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Previous Due',
                                  hintText: 'Amount'),
                            ),
                          ),
                        ],
                      ),
                      isExpanded: expanded,
                    ),
                  ],
                ),
                ButtonGlobalWithoutIcon(
                    buttontext: 'Save',
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      for (var element in customerData.value!) {
                        if (element.phoneNumber == phoneNumber) {
                          EasyLoading.showError('Phone number already exist');
                          isPhoneAlready = true;
                          Navigator.pop(context);
                        }
                      }
                      Future.delayed(const Duration(milliseconds: 500), () async {
                        if (isPhoneAlready) {
                        } else {
                          try {
                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            // ignore: no_leading_underscores_for_local_identifiers
                            final DatabaseReference _customerInformationRef = FirebaseDatabase.instance
                                // ignore: deprecated_member_use
                                .reference()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('Contact');
                            CustomerModel customerModel = CustomerModel(
                              customerName,
                              phoneNumber,
                              radioItem,
                              profilePicture,
                              emailAddress,
                              customerAddress,
                              dueAmount,
                            );
                            await _customerInformationRef.push().set(customerModel.toJson());
                            EasyLoading.showSuccess('Added Successfully!');
                            ref.refresh(customerProvider);
                            Future.delayed(const Duration(milliseconds: 100), () {
                              Navigator.pop(context);
                            });
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      });
                    },
                    buttonTextColor: Colors.white),
              ],
            ),
          ),
        );
      }),
    );
  }
}

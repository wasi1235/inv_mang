// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';
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
import 'customer_list.dart';

// ignore: must_be_immutable
class EditCustomer extends StatefulWidget {
  EditCustomer({Key? key, required this.customerModel}) : super(key: key);
  CustomerModel customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  late CustomerModel updatedCustomerModel;
  String groupValue = '';
  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  bool expanded = false;
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  double progress = 0.0;
  XFile? pickedImage;
  late String customerKey;
  void getCustomerKey(String phoneNumber) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseDatabase.instance.ref(userId).child('Person').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot =
          await FirebaseStorage.instance.ref('Person Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      EasyLoading.showSuccess('Upload Successful!');
      setState(() {
        updatedCustomerModel.profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  void initState() {
    getCustomerKey(widget.customerModel.phoneNumber);
    updatedCustomerModel = widget.customerModel;
    groupValue = widget.customerModel.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Update Contact',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Consumer(builder: (context, ref, __) {
          // ignore: unused_local_variable
          final customerData = ref.watch(customerProvider);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      initialValue: widget.customerModel.phoneNumber,
                      readOnly: true,
                      textFieldType: TextFieldType.PHONE,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      initialValue: widget.customerModel.customerName,
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          updatedCustomerModel.customerName = value;
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
                              updatedCustomerModel.type = value.toString();
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
                              updatedCustomerModel.type = value.toString();
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
                              updatedCustomerModel.type = value.toString();
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
                              updatedCustomerModel.type = value.toString();
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
                                      image: NetworkImage(updatedCustomerModel.profilePicture),
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
                                                      pickedImage =
                                                          await _picker.pickImage(source: ImageSource.gallery);
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
                                initialValue: widget.customerModel.emailAddress,
                                textFieldType: TextFieldType.EMAIL,
                                onChanged: (value) {
                                  setState(() {
                                    updatedCustomerModel.emailAddress = value;
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
                                initialValue: widget.customerModel.customerAddress,
                                textFieldType: TextFieldType.NAME,
                                maxLines: 2,
                                onChanged: (value) {
                                  setState(() {
                                    updatedCustomerModel.customerAddress = value;
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
                                readOnly: true,
                                initialValue: widget.customerModel.dueAmount,
                                textFieldType: TextFieldType.NAME,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'Previous Due'),
                              ),
                            ),
                          ],
                        ),
                        isExpanded: expanded,
                      ),
                    ],
                  ),
                  ButtonGlobalWithoutIcon(
                      buttontext: 'Update',
                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                      onPressed: () async {
                        try {
                          EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref("${FirebaseAuth.instance.currentUser!.uid}/Person/$customerKey");
                          await ref.update({
                            'personName': updatedCustomerModel.customerName,
                            'type': updatedCustomerModel.type,
                            'profilePicture': updatedCustomerModel.profilePicture,
                            'emailAddress': updatedCustomerModel.emailAddress,
                            'personAddress': updatedCustomerModel.customerAddress,
                          });
                          EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                          //ref.refresh(productProvider);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            cRef.refresh(customerProvider);
                            const CustomerList().launch(context, isNewTask: true);
                          });
                        } catch (e) {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      buttonTextColor: Colors.white),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/GlobalComponents/category_list.dart';
import 'package:mobile_pos/Screens/Products/brands_list.dart';
import 'package:mobile_pos/Screens/Products/unit_list.dart';
import 'package:mobile_pos/Screens/Sales/sales_list.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/Model/category_model.dart';
import '../../Provider/product_provider.dart';
import '../../constant.dart';

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  AddProduct({Key? key, this.catName, this.unitsName, this.brandName}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var catName;
  // ignore: prefer_typing_uninitialized_variables
  var unitsName;
  // ignore: prefer_typing_uninitialized_variables
  var brandName;
  @override
  // ignore: library_private_types_in_public_api
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GetCategoryAndVariationModel data = GetCategoryAndVariationModel(variations: [], categoryName: '');
  String productCategory = 'Select Product Category';
  String brandName = 'Select Brand';
  String productUnit = 'Select Unit';
  late String productName, productStock, productSalePrice, productPurchasePrice, productCode;
  String productWholeSalePrice = '0';
  String productDealerPrice = '0';
  String productPicture = 'https://tasteofasia.com.au/uploads/2/products/undefine.jpg';
  String productDiscount = 'Not Provided';
  String productManufacturer = 'Not Provided';
  String size = 'Not Provided';
  String color = 'Not Provided';
  String weight = 'Not Provided';
  String capacity = 'Not Provided';
  String type = 'Not Provided';
  List<String> catItems = [];
  bool showProgress = false;
  double progress = 0.0;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  List<String> codeList = [];
  String promoCodeHint = 'Code';

  int loop = 0;

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot =
          await FirebaseStorage.instance.ref('Product Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      EasyLoading.showSuccess('Upload Successful!');
      setState(() {
        productPicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if (codeList.contains(barcodeScanRes)) {
      EasyLoading.showError('This Product Already added!');
    } else {
      if (barcodeScanRes != '-1') {
        setState(() {
          productCode = barcodeScanRes;
          promoCodeHint = barcodeScanRes;
        });
      }
    }
  }

  @override
  void initState() {
    widget.catName == null ? productCategory = 'Select Product Category' : productCategory = widget.catName;
    widget.unitsName == null ? productUnit = 'Select Units' : productUnit = widget.unitsName;
    widget.brandName == null ? brandName = 'Select Brands' : brandName = widget.brandName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loop++;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Add New Product',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, __) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: FirebaseDatabase.instance
                      // ignore: deprecated_member_use
                      .reference()
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .child('Products'),
                  itemBuilder: (context, snapshot, animation, index) {
                    final json = snapshot.value as Map<dynamic, dynamic>;
                    final product = ProductModel.fromJson(json);
                    codeList.add(product.productCode);
                    return Container();
                  },
                ).visible(loop <= 1),
                const SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: showProgress,
                  child: const CircularProgressIndicator(
                    color: kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        productName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Product name',
                      hintText: 'JSW Sheet',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: kGreyTextColor),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        data = await const CategoryList().launch(context);
                        setState(() {
                          productCategory = data.categoryName;
                        });
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(productCategory),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              size = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Size',
                            hintText: '5MM',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(data.variations.contains('Size')),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              color = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Color',
                            hintText: 'Grey',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(data.variations.contains('Color')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              weight = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Weight',
                            hintText: '1 KG',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(data.variations.contains('Weight')),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              capacity = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Capacity',
                            hintText: '2L',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ).visible(data.variations.contains('Capacity')),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Type',
                      hintText: 'Outer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ).visible(data.variations.contains('Type')),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: kGreyTextColor),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        String data = await const BrandsList().launch(context);
                        setState(() {
                          brandName = data;
                        });
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(brandName),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productCode = value;
                              promoCodeHint = value;
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Product Code',
                            hintText: promoCodeHint,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () => scanBarcodeNormal(),
                          child: Container(
                            height: 60.0,
                            width: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kGreyTextColor),
                            ),
                            child: const Image(
                              image: AssetImage('images/barcode.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productStock = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Stock',
                            hintText: '20',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 60.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              String data = await const UnitList().launch(context);
                              setState(() {
                                productUnit = data;
                              });
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(productUnit),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_down),
                                const SizedBox(
                                  width: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              productPurchasePrice = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Purchase Price',
                            hintText: '\₹3000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              productSalePrice = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Issue Price',
                            hintText: '\₹3000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              productWholeSalePrice = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Contractor Price',
                            hintText: '\₹3000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          onChanged: (value) {
                            setState(() {
                              productDealerPrice = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Others price',
                            hintText: '\₹3000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextField(
                        textFieldType: TextFieldType.PHONE,
                        onChanged: (value) {
                          setState(() {
                            productDiscount = value;
                          });
                        },
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Deduction',
                          hintText: '\₹400',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productManufacturer = value;
                            });
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Manufacturer',
                            hintText: 'JSW',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                          image: NetworkImage(productPicture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
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
                                          uploadFile(pickedImage!.path);
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            Navigator.pop(context);
                                          });
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
                                          uploadFile(pickedImage!.path);
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            Navigator.pop(context);
                                          });
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
                ButtonGlobalWithoutIcon(
                  buttontext: 'Save and Publish',
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    try {
                      EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                      // ignore: no_leading_underscores_for_local_identifiers
                      final DatabaseReference _productInformationRef = FirebaseDatabase.instance
                          // ignore: deprecated_member_use
                          .reference()
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .child('Products');
                      ProductModel productModel = ProductModel(
                          productName,
                          productCategory,
                          size,
                          color,
                          weight,
                          capacity,
                          type,
                          brandName,
                          productCode,
                          productStock,
                          productUnit,
                          productSalePrice,
                          productPurchasePrice,
                          productDiscount,
                          productWholeSalePrice,
                          productDealerPrice,
                          productManufacturer,
                          productPicture);
                      await _productInformationRef.push().set(productModel.toJson());
                      EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                      ref.refresh(productProvider);
                      Future.delayed(const Duration(milliseconds: 100), () {
                        const SalesScreen().launch(context, isNewTask: true);
                      });
                    } catch (e) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

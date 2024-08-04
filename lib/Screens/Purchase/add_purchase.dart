import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_products.dart';
import 'package:mobile_pos/Screens/Report/Screens/purchase_report.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart_purchase.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/purchase_report_provider.dart';
import '../../constant.dart';
import '../Customers/Model/customer_model.dart';
import '../Home/home.dart';
import '../Sales/Model/sales_report.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  late PurchaseTransitionModel transitionModel = PurchaseTransitionModel(
    customerName: widget.customerModel.customerName,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    invoiceNumber: DateTime.now().microsecondsSinceEpoch.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifierPurchase);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Add Purchase',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       FeatherIcons.settings,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        readOnly: true,
                        initialValue: transitionModel.invoiceNumber,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Tracking No.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        readOnly: true,
                        initialValue: transitionModel.purchaseDate,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Date',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                initialDate: selectedDate,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101),
                                context: context,
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                  transitionModel.purchaseDate = selectedDate.toString();
                                });
                              }
                            },
                            icon: const Icon(FeatherIcons.calendar),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Due Amount: '),
                        Text(
                          widget.customerModel.dueAmount == '' ? '\₹ 0' : '\₹${widget.customerModel.dueAmount}',
                          style: const TextStyle(color: Color(0xFFFF8C34)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      initialValue: widget.customerModel.customerName,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Person Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ///_______Added_ItemS__________________________________________________
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    border: Border.all(width: 1, color: const Color(0xffEAEFFA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xffEAEFFA),
                            borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Item Added',
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: providerData.cartItemPurchaseList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        providerData.cartItemPurchaseList[index].productName.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Text('Quantity')
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(providerData.cartItemPurchaseList[index].brandName.toString()),
                                      Text(providerData.cartItemPurchaseList[index].productStock),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: const Color(0xffEAEFFA),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ).visible(providerData.cartItemPurchaseList.isNotEmpty),
                ),
                const SizedBox(
                  height: 20,
                ),

                ///_______Add_Button__________________________________________________
                GestureDetector(
                  onTap: () {
                    PurchaseProducts(
                      catName: null,
                      customerModel: widget.customerModel,
                    ).launch(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: kMainColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                          'Add Items',
                          style: TextStyle(color: kMainColor, fontSize: 20),
                        )),
                  ),
                ),
                const SizedBox(height: 20),

                ///_____Total______________________________
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey.shade300, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color(0xffEAEFFA),
                            borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub Total',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              providerData.getTotalAmount().toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Deduction',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: context.width() / 4,
                              child: TextField(
                                onChanged: (value) {
                                  if (value == '') {
                                    setState(() {
                                      discountAmount = 0;
                                    });
                                  } else {
                                    setState(() {
                                      discountAmount = double.parse(value);
                                    });
                                  }
                                },
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateSubtotal(total: providerData.getTotalAmount()).toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Settled Amount',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: context.width() / 4,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value == '') {
                                    setState(() {
                                      paidAmount = 0;
                                    });
                                  } else {
                                    setState(() {
                                      paidAmount = double.parse(value);
                                    });
                                  }
                                },
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(hintText: '0'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Reverse Amount',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateReturnAmount(total: subTotal).abs().toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Due Amount',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              calculateDueAmount(total: subTotal).toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Payment Type',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.wallet,
                          color: Colors.green,
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Cash',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(Icons.arrow_drop_down_sharp),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Description',
                          hintText: 'Add Note',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade200),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                FeatherIcons.camera,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Image',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              )
                            ],
                          ),
                        )),
                  ],
                ).visible(false),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (providerData.cartItemPurchaseList.isNotEmpty) {
                              try {
                                EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                                final userId = FirebaseAuth.instance.currentUser!.uid;
                                DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Purchase Transition");

                                dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                                dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                                returnAmount < 0
                                    ? transitionModel.returnAmount = returnAmount.abs()
                                    : transitionModel.returnAmount = 0;
                                transitionModel.discountAmount = discountAmount;
                                transitionModel.totalAmount = subTotal;
                                transitionModel.productList = providerData.cartItemPurchaseList;
                                await ref.push().set(transitionModel.toJson());

                                ///__________StockMange_________________________________________________-

                                for (var element in providerData.cartItemPurchaseList) {
                                  increaseStock(productCode: element.productCode, productModel: element);
                                }

                                ///_________DueUpdate______________________________________________________
                                getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: dueAmount.toInt());

                                ///____Issue_report__________________________________________________________
                                final DatabaseReference salesReportRef = FirebaseDatabase.instance
                                    .ref()
                                    .child(FirebaseAuth.instance.currentUser!.uid)
                                    .child('Issue Report');
                                SalesReport salesReport = SalesReport(widget.customerModel.customerName,
                                    subTotal.toString(), providerData.cartItemPurchaseList.length.toString());
                                await salesReportRef.push().set(salesReport.toJson());
                                providerData.clearCart();
                                consumerRef.refresh(customerProvider);
                                consumerRef.refresh(productProvider);
                                consumerRef.refresh(purchaseReportProvider);
                                consumerRef.refresh(purchaseTransitionProvider);
                                EasyLoading.showSuccess('Added Successfully');
                                // ignore: use_build_context_synchronously
                                const Home().launch(context, isNewTask: true);
                              } catch (e) {
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            } else {
                              EasyLoading.showError('Add Product first');
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                'Save & New',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (providerData.cartItemPurchaseList.isNotEmpty) {
                            try {
                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                              final userId = FirebaseAuth.instance.currentUser!.uid;
                              DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Purchase Transition");

                              dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                              dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                              returnAmount < 0
                                  ? transitionModel.returnAmount = returnAmount.abs()
                                  : transitionModel.returnAmount = 0;
                              transitionModel.discountAmount = discountAmount;
                              transitionModel.totalAmount = subTotal;
                              transitionModel.productList = providerData.productList;
                              await ref.push().set(transitionModel.toJson());

                              ///__________StockMange_________________________________________________-

                              for (var element in providerData.cartItemPurchaseList) {
                                increaseStock(productCode: element.productCode, productModel: element);
                              }

                              ///_________DueUpdate______________________________________________________
                              getSpecificCustomers(
                                  phoneNumber: widget.customerModel.phoneNumber, due: dueAmount.toInt());

                              ///____Issue_report__________________________________________________________
                              final DatabaseReference salesReportRef = FirebaseDatabase.instance
                                  .ref()
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('Purchase Report');
                              SalesReport salesReport = SalesReport(widget.customerModel.customerName,
                                  subTotal.toString(), providerData.cartItemPurchaseList.length.toString());
                              await salesReportRef.push().set(salesReport.toJson());

                              providerData.clearCart();
                              consumerRef.refresh(customerProvider);
                              consumerRef.refresh(productProvider);
                              consumerRef.refresh(purchaseReportProvider);
                              consumerRef.refresh(purchaseTransitionProvider);

                              EasyLoading.showSuccess('Added Successfully');
                              // ignore: use_build_context_synchronously
                              const PurchaseReportScreen().launch(context, isNewTask: true);
                            } catch (e) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                          } else {
                            EasyLoading.showError('Add product first');
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void increaseStock({required String productCode, required ProductModel productModel}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Products/');

    var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock + productModel.productStock.toInt();

    ref.child(productPath).update({
      'productIssuePrice': productModel.productSalePrice,
      'productPurchasePrice': productModel.productPurchasePrice,
      'productContractorPrice': productModel.productWholeSalePrice,
      'productOthersPrice': productModel.productDealerPrice,
      'productStock': '$remainStock',
    });
  }

  void getSpecificCustomers({required String phoneNumber, required int due}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Person/');
    String? key;

    await FirebaseDatabase.instance.ref(userId).child('person').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
        }
      }
    });
    var data1 = await ref.child('$key/due').once();
    int previousDue = data1.snapshot.value.toString().toInt();

    int totalDue = previousDue + due;
    ref.child(key!).update({'due': '$totalDue'});
  }
}
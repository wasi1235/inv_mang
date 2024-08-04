import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Customers/edit_customer.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GlobalComponents/button_global.dart';
import 'Model/customer_model.dart';

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  CustomerDetails({Key? key, required this.customerModel}) : super(key: key);

  CustomerModel customerModel;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late String customerKey;
  String buttonsSelected = '';

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

  @override
  void initState() {
    getCustomerKey(widget.customerModel.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, cRef, __) {
      final providerData = cRef.watch(transitionProvider);
      final providerDataPurchase = cRef.watch(purchaseTransitionProvider);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Person Details',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                EditCustomer(customerModel: widget.customerModel).launch(context);
              },
              icon: const Icon(
                FeatherIcons.edit2,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () async {
                DatabaseReference ref =
                    FirebaseDatabase.instance.ref("${FirebaseAuth.instance.currentUser!.uid}/Customers/$customerKey");
                await ref.remove();
                cRef.refresh(customerProvider);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              icon: const Icon(
                FeatherIcons.trash2,
                color: Colors.grey,
              ),
            ),
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(widget.customerModel.profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.customerModel.customerName,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.customerModel.phoneNumber,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('tel:${widget.customerModel.phoneNumber}');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }

                      setState(() {
                        buttonsSelected = 'Call';
                      });
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: buttonsSelected == 'Call' ? kMainColor : kMainColor.withOpacity(0.10),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FeatherIcons.phone,
                              size: 25,
                              color: buttonsSelected == 'Call' ? Colors.white : Colors.black,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Call',
                              style: TextStyle(
                                fontSize: 20,
                                color: buttonsSelected == 'Call' ? Colors.white : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse('sms:${widget.customerModel.phoneNumber}');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                      setState(() {
                        buttonsSelected = 'Message';
                      });
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: buttonsSelected == 'Message' ? kMainColor : kMainColor.withOpacity(0.10),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FeatherIcons.messageSquare,
                              size: 25,
                              color: buttonsSelected == 'Message' ? Colors.white : Colors.black,
                            ),
                            Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 20,
                                color: buttonsSelected == 'Message' ? Colors.white : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // const subject = 'test';
                      // const message = 'test for email';
                      // const mail ='tahmidtarongo@gmail.com';
                      // final Uri url = Uri.parse('mailto:$mail?subject=$subject&body=$message');
                      //
                      // if (await canLaunchUrl(url)) {
                      // await launchUrl(url);
                      // }
                      setState(() {
                        buttonsSelected = 'Email';
                      });
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          color: buttonsSelected == 'Email' ? kMainColor : kMainColor.withOpacity(0.10),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FeatherIcons.mail,
                              size: 25,
                              color: buttonsSelected == 'Email' ? Colors.white : Colors.black,
                            ),
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 20,
                                color: buttonsSelected == 'Email' ? Colors.white : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18),
              ),
             widget.customerModel.type != 'Supplier'? providerData.when(data: (transaction) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transaction.length,
                  itemBuilder: (context, index) {
                    return transaction[index].customerPhone == widget.customerModel.phoneNumber
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: context.width(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Products : ${transaction[index].productList!.length.toString()}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text('#${transaction[index].invoiceNumber}'),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: transaction[index].dueAmount! <= 0
                                                  ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                  : const Color(0xFFED1A3B).withOpacity(0.1),
                                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Text(
                                            transaction[index].dueAmount! <= 0 ? 'Settled' : 'Unsettled',
                                            style: TextStyle(
                                                color: transaction[index].dueAmount! <= 0
                                                    ? const Color(0xff0dbf7d)
                                                    : const Color(0xFFED1A3B)),
                                          ),
                                        ),
                                        Text(
                                          transaction[index].purchaseDate.substring(0, 10),
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Total : \₹ ${transaction[index].totalAmount.toString()}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Due: \₹ ${transaction[index].dueAmount.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  FeatherIcons.printer,
                                                  color: Colors.grey,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  FeatherIcons.share,
                                                  color: Colors.grey,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  FeatherIcons.moreVertical,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 0.5,
                                width: context.width(),
                                color: Colors.grey,
                              )
                            ],
                          )
                        : Container();
                  },
                );
              }, error: (e, stack) {
                return Text(e.toString());
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              }) : providerDataPurchase.when(data: (transaction) {
               return ListView.builder(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: transaction.length,
                 itemBuilder: (context, index) {
                   return transaction[index].customerPhone == widget.customerModel.phoneNumber
                       ? Column(
                     children: [
                       Container(
                         padding: const EdgeInsets.all(20),
                         width: context.width(),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Total Products : ${transaction[index].productList!.length.toString()}",
                                   style: const TextStyle(fontSize: 16),
                                 ),
                                 Text('#${transaction[index].invoiceNumber}'),
                               ],
                             ),
                             const SizedBox(height: 10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: const EdgeInsets.all(8),
                                   decoration: BoxDecoration(
                                       color: transaction[index].dueAmount! <= 0
                                           ? const Color(0xff0dbf7d).withOpacity(0.1)
                                           : const Color(0xFFED1A3B).withOpacity(0.1),
                                       borderRadius: const BorderRadius.all(Radius.circular(10))),
                                   child: Text(
                                     transaction[index].dueAmount! <= 0 ? 'Settled' : 'Unsettled',
                                     style: TextStyle(
                                         color: transaction[index].dueAmount! <= 0
                                             ? const Color(0xff0dbf7d)
                                             : const Color(0xFFED1A3B)),
                                   ),
                                 ),
                                 Text(
                                   transaction[index].purchaseDate.substring(0, 10),
                                   style: const TextStyle(color: Colors.grey),
                                 ),
                               ],
                             ),
                             const SizedBox(height: 10),
                             Text(
                               'Total : \₹ ${transaction[index].totalAmount.toString()}',
                               style: const TextStyle(color: Colors.grey),
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   'Due: \₹ ${transaction[index].dueAmount.toString()}',
                                   style: const TextStyle(fontSize: 16),
                                 ),
                                 Row(
                                   children: [
                                     IconButton(
                                         onPressed: () {},
                                         icon: const Icon(
                                           FeatherIcons.printer,
                                           color: Colors.grey,
                                         )),
                                     IconButton(
                                         onPressed: () {},
                                         icon: const Icon(
                                           FeatherIcons.share,
                                           color: Colors.grey,
                                         )),
                                     IconButton(
                                         onPressed: () {},
                                         icon: const Icon(
                                           FeatherIcons.moreVertical,
                                           color: Colors.grey,
                                         )),
                                   ],
                                 )
                               ],
                             ),
                           ],
                         ),
                       ),
                       Container(
                         height: 0.5,
                         width: context.width(),
                         color: Colors.grey,
                       )
                     ],
                   )
                       : Container();
                 },
               );
             }, error: (e, stack) {
               return Text(e.toString());
             }, loading: () {
               return const Center(child: CircularProgressIndicator());
             }),

            ],
          ),
        ),
        bottomNavigationBar: ButtonGlobal(
          iconWidget: null,
          buttontext: 'View All',
          iconColor: Colors.white,
          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
          onPressed: () {},
        ),
      );
    });
  }
}

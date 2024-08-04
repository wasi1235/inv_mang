import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/profile_provider.dart';
import '../../Home/home.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Issue Report',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(transitionProvider);
          // ignore: unused_local_variable
          final customerData = ref.watch(customerProvider);
          // ignore: unused_local_variable
          final cartData = ref.watch(cartNotifier);
          final printerData = ref.watch(printerProviderNotifier);
          final personalData = ref.watch(profileDetailsProvider);
          return SingleChildScrollView(
            child: providerData.when(data: (transaction) {
              return transaction.isNotEmpty ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transaction.length,
                itemBuilder: (context, index) {
                  return Column(
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
                                  transaction[index].customerName,
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
                                    transaction[index].dueAmount! <= 0 ? 'Paid' : 'Unpaid',
                                    style: TextStyle(color: transaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
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
                              'Total : \$ ${transaction[index].totalAmount.toString()}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due: \$ ${transaction[index].dueAmount.toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                personalData.when(data: (data) {
                                  return Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await printerData.getBluetooth();
                                            PrintTransactionModel model = PrintTransactionModel(
                                              transitionModel: transaction[index],
                                              personalInformationModel: data
                                            );
                                            printerData.connected
                                                ? printerData.printTicket(printTransactionModel: model, productList: model.transitionModel!.productList)
                                                : showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return Dialog(
                                                        child: SizedBox(
                                                          height: 200,
                                                          child: ListView.builder(
                                                            itemCount: printerData.availableBluetoothDevices.isNotEmpty
                                                                ? printerData.availableBluetoothDevices.length
                                                                : 0,
                                                            itemBuilder: (context, index) {
                                                              return ListTile(
                                                                onTap: () async {
                                                                  String select = printerData.availableBluetoothDevices[index];
                                                                  List list = select.split("#");
                                                                  // String name = list[0];
                                                                  String mac = list[1];
                                                                  bool isConnect = await printerData.setConnect(mac);
                                                                  // ignore: use_build_context_synchronously
                                                                  isConnect ? finish(context) : toast('Try Again');
                                                                },
                                                                title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                subtitle: const Text("Click to connect"),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    });
                                          },
                                          icon: const Icon(
                                            FeatherIcons.printer,
                                            color: Colors.grey,
                                          )),
                                      IconButton(
                                          onPressed: () => toast('Coming Soon'),
                                          icon: const Icon(
                                            FeatherIcons.share,
                                            color: Colors.grey,
                                          )),
                                      IconButton(
                                          onPressed: () => toast('Coming Soon'),
                                          icon: const Icon(
                                            FeatherIcons.moreVertical,
                                            color: Colors.grey,
                                          )),
                                    ],
                                  );
                                }, error: (e, stack) {
                                  return Text(e.toString());
                                }, loading: () {
                                  return const Text('Loading');
                                }),
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
                  );
                },
              ): const Center(
                child: Text(
                  'Please Add A Sale',
                  maxLines: 2,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          );
        }),
      ),
    );
  }
}

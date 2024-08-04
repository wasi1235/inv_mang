import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/due_transaction_provider.dart';
import '../../Home/home.dart';

class DueReportScreen extends StatefulWidget {
  const DueReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DueReportScreenState createState() => _DueReportScreenState();
}

class _DueReportScreenState extends State<DueReportScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Due Report',
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
          final providerData = ref.watch(dueTransactionProvider);
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
                                      color: transaction[index].dueAmountAfterPay! <= 0
                                          ? const Color(0xff0dbf7d).withOpacity(0.1)
                                          : const Color(0xFFED1A3B).withOpacity(0.1),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    transaction[index].dueAmountAfterPay! <= 0 ? 'Fully Paid' : 'Still Unpaid',
                                    style: TextStyle(
                                        color: transaction[index].dueAmountAfterPay! <= 0
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
                              'Total : \$ ${transaction[index].totalDue.toString()}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Due: \$ ${transaction[index].dueAmountAfterPay.toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => toast('Coming Soon'),
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
                  );
                },
              ) : const Center(
                child: Text(
                  'Please Collect A Due',
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

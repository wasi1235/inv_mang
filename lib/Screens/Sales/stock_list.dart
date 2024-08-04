import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../model/product_model.dart';

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;

  @override
  void initState() {
    getAllTotal();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock List',
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10.0),
                    DataTable(
                      horizontalMargin: 20.0,
                      columnSpacing: 50.0,
                      headingRowColor: MaterialStateColor.resolveWith((states) => kMainColor.withOpacity(0.2)),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Product',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'QTY',
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 70,
                            child: Text(
                              'Purchase Price',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 60,
                            child: Text(
                              'Issue Price',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                      rows: const [],
                    ),
                    providerData.when(data: (product) {
                      return ListView.builder(
                          itemCount: product.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product[index].productName,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          product[index].brandName,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            color:
                                                product[index].productStock.toInt() < 20 ? Colors.red : kGreyTextColor,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        product[index].productStock,
                                        style: GoogleFonts.poppins(
                                          color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          '\₹${product[index].productPurchasePrice}',
                                          style: GoogleFonts.poppins(
                                            color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '\₹${product[index].productSalePrice}',
                                        style: GoogleFonts.poppins(
                                          color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        height: 60,
        color: kMainColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Total',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  totalStock.toString(),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    '\₹${totalParPrice.toString()}',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                  )),
              SizedBox(
                width: 80,
                child: Text(
                  '\₹${totalSalePrice.toString()}',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAllTotal() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(userId).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        totalStock = totalStock + int.parse(data['productStock']);
        totalSalePrice = totalSalePrice + (int.parse(data['productIssuePrice']) * int.parse(data['productStock']));
        totalParPrice = totalParPrice + (int.parse(data['productPurchasePrice']) * int.parse(data['productStock']));

        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Screens/Customers/add_customer.dart';
import 'package:mobile_pos/Screens/Sales/add_sales.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../constant.dart';

class SalesContact extends StatefulWidget {
  const SalesContact({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesContactState createState() => _SalesContactState();
}

class _SalesContactState extends State<SalesContact> {
  Color color = Colors.black26;
  String searchCustomer = '';
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(customerProvider);
      final cart = ref.watch(cartNotifier);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Choose a Person',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: providerData.when(data: (customer) {
              return customer.isNotEmpty? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search,
                          color: kGreyTextColor.withOpacity(0.5),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchCustomer = value;
                        });
                      },
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: customer.length,
                      itemBuilder: (_, index) {
                        customer[index].type == 'Client' ? color = const Color(0xFF56da87) : Colors.white;
                        customer[index].type == 'Contractor' ? color = const Color(0xFF25a9e0) : Colors.white;
                        customer[index].type == 'Others' ? color = const Color(0xFFff5f00) : Colors.white;
                        customer[index].type == 'Supplier' ? color = const Color(0xFFA569BD) : Colors.white;
                        return customer[index].customerName.contains(searchCustomer) &&
                                !customer[index].type.contains('Supplier')
                            ? GestureDetector(
                                onTap: () {
                                  AddSalesScreen(customerModel: customer[index]).launch(context);
                                  cart.clearCart();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CircleAvatar(
                                          foregroundColor: Colors.blue,
                                          backgroundColor: Colors.white,
                                          radius: 70.0,
                                          child: ClipOval(
                                            child: Image.network(
                                              customer[index].profilePicture,
                                              fit: BoxFit.cover,
                                              width: 120.0,
                                              height: 120.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer[index].customerName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            customer[index].type,
                                            style: GoogleFonts.poppins(
                                              color: color,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\₹ ${customer[index].dueAmount}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            'Due',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFFff5f00),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ).visible(customer[index].dueAmount != '' && customer[index].dueAmount != '0'),
                                      const SizedBox(width: 20),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: kGreyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      }),
                ],
              ): const Center(
                child: Text(
                  'Please Add A Person',
                  maxLines: 2,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              const AddCustomer().launch(context);
            }),
      );
    });
  }
}

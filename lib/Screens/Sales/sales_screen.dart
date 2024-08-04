import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../model/add_to_cart_model.dart';

// ignore: must_be_immutable
class SaleProducts extends StatefulWidget {
  SaleProducts({Key? key, @required this.catName, this.customerModel}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  CustomerModel? customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _SaleProductsState createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String productPrice = '0';
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Cement' : dropdownValue = widget.catName;
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      final productList = ref.watch(productProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Issue Details',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (BuildContext bc) => [
          //       const PopupMenuItem(value: "/addPromoCode", child: Text('Add Promo Code')),
          //       const PopupMenuItem(value: "clear", child: Text('Cancel All Product')),
          //       const PopupMenuItem(value: "/settings", child: Text('Vat Doesn\'t Apply')),
          //     ],
          //     onSelected: (value) {
          //       value == 'clear'
          //           ? {
          //               providerData.clearCart(),
          //               providerData.clearDiscount(),
          //               const HomeScreen().launch(context, isNewTask: true)
          //             }
          //           : Navigator.pushNamed(context, '$value');
          //     },
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   height: 60.0,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //     color: kMainColor,
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                //   child: GestureDetector(
                //     onTap: () {
                //       // ignore: missing_required_param
                //       providerData.getTotalAmount() <= 0
                //           ? EasyLoading.showError('Cart Is Empty')
                //           : SalesDetails(
                //               customerName: widget.customerModel!.customerName,
                //             ).launch(context);
                //     },
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 1,
                //           child: Stack(
                //             alignment: Alignment.center,
                //             children: [
                //               const Image(
                //                 image: AssetImage('images/selected.png'),
                //               ),
                //               Text(
                //                 items.toString(),
                //                 style: GoogleFonts.poppins(
                //                   fontSize: 15.0,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Expanded(
                //           flex: 2,
                //           child: Center(
                //             child: Text(
                //               providerData.getTotalAmount() <= 0
                //                   ? 'Cart is empty'
                //                   : 'Total: \$${providerData.getTotalAmount().toString()}',
                //               style: GoogleFonts.poppins(
                //                 color: Colors.white,
                //                 fontSize: 16.0,
                //               ),
                //             ),
                //           ),
                //         ),
                //         const Expanded(
                //           flex: 1,
                //           child: Icon(
                //             Icons.arrow_forward,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20.0,
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
                            });
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Product Code',
                            hintText:
                                productCode == '0000' || productCode == '-1' ? 'Scan product QR code' : productCode,
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
                productList.when(data: (products) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        if (widget.customerModel!.type.contains('Client')) {
                          productPrice = products[i].productSalePrice;
                        } else if (widget.customerModel!.type.contains('Others')) {
                          productPrice = products[i].productDealerPrice;
                        } else if (widget.customerModel!.type.contains('Contractor')) {
                          productPrice = products[i].productWholeSalePrice;
                        } else if (widget.customerModel!.type.contains('Supplier')) {
                          productPrice = products[i].productPurchasePrice;
                        }
                        return GestureDetector(
                          onTap: () async {
                            if (products[i].productStock.toInt() <= 0) {
                              EasyLoading.showError('Out of stock');
                            } else {
                              if (widget.customerModel!.type.contains('Client')) {
                                sentProductPrice = products[i].productSalePrice;
                              } else if (widget.customerModel!.type.contains('Others')) {
                                sentProductPrice = products[i].productDealerPrice;
                              } else if (widget.customerModel!.type.contains('Contractor')) {
                                sentProductPrice = products[i].productWholeSalePrice;
                              } else if (widget.customerModel!.type.contains('Supplier')) {
                                sentProductPrice = products[i].productPurchasePrice;
                              }

                              AddToCartModel cartItem = AddToCartModel(
                                productName: products[i].productName,
                                subTotal: sentProductPrice,
                                productId: products[i].productCode,
                                productBrandName: products[i].brandName,
                                stock: int.parse(products[i].productStock),
                              );
                              providerData.addToCartRiverPod(cartItem);
                              providerData.addProductsInSales(products[i]);
                              EasyLoading.showSuccess('Added To Cart');
                              Navigator.pop(context);
                            }
                          },
                          child: ProductCard(
                            productTitle: products[i].productName,
                            productDescription: products[i].brandName,
                            productPrice: productPrice,
                            productImage: products[i].productPicture,
                          ).visible((products[i].productCode == productCode ||
                                  productCode == '0000' ||
                                  productCode == '-1') &&
                              productPrice != '0'),
                        );
                      });
                }, error: (e, stack) {
                  return Text(e.toString());
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: Icons.arrow_forward,
        //   buttontext: 'Sales List',
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        //   onPressed: () {
        //     // ignore: missing_required_param
        //     providerData.getTotalAmount() <= 0
        //         ? EasyLoading.showError('Cart Is Empty')
        //         : SalesDetails(
        //             customerName: widget.customerModel!.customerName,
        //           ).launch(context);
        //   },
        // ),
      );
    });
  }

}

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard(
      {Key? key,
      required this.productTitle,
      required this.productDescription,
      required this.productPrice,
      required this.productImage})
      : super(key: key);

  // final Product product;
  String productImage, productTitle, productDescription, productPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(widget.productImage), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.productTitle,
                        style: GoogleFonts.jost(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      // const SizedBox(width: 5),
                      // Text(
                      //   ' X $quantity',
                      //   style: GoogleFonts.jost(
                      //     fontSize: 14.0,
                      //     color: Colors.grey.shade500,
                      //   ),
                      // ).visible(quantity != 0),
                    ],
                  ),
                  Text(
                    widget.productDescription,
                    style: GoogleFonts.jost(
                      fontSize: 15.0,
                      color: kGreyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '\₹${widget.productPrice}',
              style: GoogleFonts.jost(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}

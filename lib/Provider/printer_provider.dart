import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/add_to_cart_model.dart';
import '../model/print_transaction_model.dart';

class Printer extends ChangeNotifier {
  bool connected = false;
  List availableBluetoothDevices = [];
  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    availableBluetoothDevices = bluetooths!;
    notifyListeners();
  }

  Future<bool> setConnect(String mac) async {
    bool status = false;
    final String? result = await BluetoothThermalPrinter.connect(mac);
    if (result == "true") {
      connected = true;
      status = true;
    }
    notifyListeners();
    return status;
  }

  Future<bool> printTicket({required PrintTransactionModel printTransactionModel, required List<AddToCartModel>? productList}) async {
    bool isPrinted = false;
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(printTransactionModel: printTransactionModel,productList: productList);
      if(productList!.isNotEmpty){
        await BluetoothThermalPrinter.writeBytes(bytes);
      }else{
        toast('No Product Found');
      }

      isPrinted = true;
    } else {
      isPrinted = false;
    }
    notifyListeners();
    return isPrinted;
  }

  Future<List<int>> getTicket({required PrintTransactionModel printTransactionModel,  required List<AddToCartModel>? productList}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    // final ByteData data = await rootBundle.load('images/logo.png');
    // final Uint8List imageBytes = data.buffer.asUint8List();
    // final images.Image? imagez = decodeImage(imageBytes);
    // bytes += generator.image(imagez!);
    bytes += generator.text(printTransactionModel.personalInformationModel.companyName ?? '',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text(printTransactionModel.personalInformationModel.countryName ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: ${printTransactionModel.personalInformationModel.phoneNumber ?? ''}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Name: ${printTransactionModel.transitionModel?.customerName ?? 'Guest'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('mobile: ${printTransactionModel.transitionModel?.customerPhone ?? 'Not Provided'}', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Item', width: 5, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'Total', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    List.generate(productList?.length ?? 1, (index) {
      return bytes += generator.row([
        PosColumn(
            text: productList?[index].productName ?? 'Not Defined',
            width: 5,
            styles: const PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: productList?[index].subTotal ?? 'Not Defined',
            width: 2,
            styles: const PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(text: productList?[index].quantity.toString() ?? 'Not Defined', width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: "${double.parse(productList?[index].subTotal) * productList![index].quantity.toInt()}", width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    });

    // bytes += generator.row([
    //   PosColumn(
    //       text: "Sada Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "30",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "30", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
    //
    // bytes += generator.row([
    //   PosColumn(
    //       text: "Masala Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "50",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "50", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
    //
    // bytes += generator.row([
    //   PosColumn(
    //       text: "Rova Dosa",
    //       width: 5,
    //       styles: PosStyles(
    //         align: PosAlign.left,
    //       )),
    //   PosColumn(
    //       text: "70",
    //       width: 2,
    //       styles: PosStyles(
    //         align: PosAlign.center,
    //       )),
    //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
    //   PosColumn(text: "70", width: 3, styles: PosStyles(align: PosAlign.right)),
    // ]);
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Subtotal',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() + printTransactionModel.transitionModel!.discountAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Discount',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.discountAmount.toString() ?? '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.totalAmount.toString() ?? '',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Payment Type:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel?.paymentType ?? 'Cash',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Payment Amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: '${printTransactionModel.transitionModel!.totalAmount!.toDouble() - printTransactionModel.transitionModel!.dueAmount!.toDouble()}',
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Return amount:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel!.returnAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Total Due:',
          width: 8,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: printTransactionModel.transitionModel!.dueAmount.toString(),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(printTransactionModel.transitionModel!.purchaseDate, styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('Note: Goods once sold will not be taken back or exchanged.',
        styles: const PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }
}

final printerProviderNotifier = ChangeNotifierProvider((ref) => Printer());
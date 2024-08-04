import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Delivery/Model/delivery_model.dart';

class DeliveryRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<DeliveryModel>> getAllDelivery() async {
    List<DeliveryModel> deliveryList = [];

    await FirebaseDatabase.instance.ref(userId).child('Delivery Addresses').orderByKey().get().then((value) {
      for (var element in value.children) {
        deliveryList.add(DeliveryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return deliveryList;
  }
}

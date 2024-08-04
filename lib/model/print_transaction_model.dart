import 'package:mobile_pos/model/personal_information_model.dart';
import 'package:mobile_pos/model/transition_model.dart';

class PrintTransactionModel {
  PrintTransactionModel({required this.transitionModel, required this.personalInformationModel});

  PersonalInformationModel personalInformationModel;
  TransitionModel? transitionModel;
}

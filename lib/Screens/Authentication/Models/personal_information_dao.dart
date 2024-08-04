import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Authentication/Models/personal_information.dart';

class PersonalInformationDao {
  final DatabaseReference _personalInformationRef =
  // ignore: deprecated_member_use
  FirebaseDatabase.instance.reference().child('Personal Information');

  void saveInformation(PersonalInformation information) {
    _personalInformationRef.set(information.toJson());
  }

  Query getInformationQuery() {
    return _personalInformationRef;
  }
}
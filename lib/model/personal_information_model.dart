

class PersonalInformationModel {
  PersonalInformationModel({
      this.phoneNumber, 
      this.companyName, 
      this.pictureUrl, 
      this.businessCategory, 
      this.language, 
      this.countryName,});

  PersonalInformationModel.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    companyName = json['companyName'];
    pictureUrl = json['pictureUrl'];
    businessCategory = json['businessCategory'];
    language = json['language'];
    countryName = json['countryName'];
  }
  dynamic phoneNumber;
  String? companyName;
  String? pictureUrl;
  String? businessCategory;
  String? language;
  String? countryName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['companyName'] = companyName;
    map['pictureUrl'] = pictureUrl;
    map['businessCategory'] = businessCategory;
    map['language'] = language;
    map['countryName'] = countryName;
    return map;
  }

}
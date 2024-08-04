class PersonalInformation {
  late String businessCategory,
      companyName,
      phoneNumber,
      countryName,
      language,
      pictureUrl;


  PersonalInformation(this.businessCategory, this.companyName, this.phoneNumber,
      this.countryName, this.language, this.pictureUrl);

  PersonalInformation.fromJson(Map<dynamic, dynamic> json)
      : businessCategory = json['businessCategory'] as String,
        companyName = json['companyName'] as String,
        phoneNumber = json['phoneNumber'] as String,
        countryName = json['countryName'] as String,
        language = json['language'] as String,
        pictureUrl = json['pictureUrl'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'businessCategory': businessCategory,
    'companyName': companyName,
    'phoneNumber': phoneNumber,
    'countryName': countryName,
    'language': language,
    'pictureUrl': pictureUrl,
  };
}

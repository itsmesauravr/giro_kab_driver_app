class ProfileFormModel {
  final String bloodGroup;
  final String houseName;
  final String location;
  final String district;
  final String state;
  final String pincode;

  ProfileFormModel({
    required this.bloodGroup,
    required this.houseName,
    required this.location,
    required this.district,
    required this.state,
    required this.pincode,
  });
    factory ProfileFormModel.fromJson(Map<String, dynamic> json) => ProfileFormModel(
        bloodGroup: json["blood_group"],
        houseName: json["house_name"],
        location: json["location"],
        district: json["district"],
        state: json["state"],
        pincode: json["pin"],
    );

    Map<String, dynamic> toJson() => {
        "blood_group": bloodGroup,
        "house_name": houseName,
        "location": location,
        "district": district,
        "state": state,
        "pin": pincode,
    };

}

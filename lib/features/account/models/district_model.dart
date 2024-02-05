class District {
  District({
    required this.id,
    required this.district,
    required this.stateId,
  });

  int id;
  String district;
  String stateId;

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        district: json["district"].toString(),
        stateId: json["state_id"].toString() ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district": district,
        "state_id": stateId,
      };
}

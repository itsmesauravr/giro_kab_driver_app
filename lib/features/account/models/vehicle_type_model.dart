class VehicleType {
    VehicleType({
      required  this.id,
      required  this.category,
      required  this.type,
    });

    int id;
    String category;
    String type;


    factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json["id"],
        category: json["category"].toString(),
        type: json["type"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "type": type,
    };
}
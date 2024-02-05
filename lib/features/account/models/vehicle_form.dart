class VehicleForm {
    VehicleForm({
      required  this.vehicleCategory,
      required  this.vehicleType,
    });

    String vehicleCategory;
    String vehicleType;

    factory VehicleForm.fromJson(Map<String, dynamic> json) => VehicleForm(
        vehicleCategory: json["vehicle_category"],
        vehicleType: json["vehicle_type"],
    );

    Map<String, dynamic> toJson() => {
        "vehicle_category": vehicleCategory,
        "vehicle_type": vehicleType,
    };
}

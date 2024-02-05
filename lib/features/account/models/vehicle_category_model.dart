class VehicleCategory {
    VehicleCategory({
       required this.id,
       required this.category,
       required this.categoryType,
       required this.icon,
    });

    int id;
    String category;
    String categoryType;
    String icon;

    factory VehicleCategory.fromJson(Map<String, dynamic> json) => VehicleCategory(
        id: json["id"],
        category: json["category"].toString(),
        categoryType: json["category_type"].toString(),
        icon: json["icon"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "category_type": categoryType,
        "icon": icon,
    };
}
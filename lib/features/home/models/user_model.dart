class UserProfile {
    UserProfile({
        required this.driverId,
        required this.name,
        required this.mobile,
        required this.photo,
        required this.franchise,
    });

    String driverId;
    String name;
    String mobile;
    String photo;
    String franchise;

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        driverId: json["driver_id"],
        name: json["name"],
        mobile: json["mobile"],
        photo: json["photo"],
        franchise: json["franchise"],
    );

    Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "name": name,
        "mobile": mobile,
        "photo": photo,
        "franchise": franchise,
    };
}

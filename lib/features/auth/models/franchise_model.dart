class Franchise {
    Franchise({
      required  this.id,
      required  this.franchiseName,
    });

    int id;
    String franchiseName;

    factory Franchise.fromJson(Map<String, dynamic> json) => Franchise(
        id: json["id"],
        franchiseName: json["franchise_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "franchise_name": franchiseName,
    };
}

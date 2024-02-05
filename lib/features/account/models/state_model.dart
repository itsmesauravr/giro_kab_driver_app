class StateAddress {
    StateAddress({
       required this.id,
       required this.state,
    });

    String id;
    String state;

    factory StateAddress.fromJson(Map<String, dynamic> json) => StateAddress(
        id: json["id"].toString(),
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
    };
}


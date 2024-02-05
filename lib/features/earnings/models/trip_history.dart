class RideHistory {
    RideHistory({
        required this.completedRidesList,
        required this.unfinishedRidesList,
        required this.completedRides,
        required this.cancelledRides,
        required this.rejectedRides,
        required this.timeoutRides,
        required this.earnings,
    });

    List<RideModel> completedRidesList;
    List<RideModel> unfinishedRidesList;
    String completedRides;
    String cancelledRides;
    String rejectedRides;
    String timeoutRides;
    String earnings;

    factory RideHistory.fromJson(Map<String, dynamic> json) => RideHistory(
        completedRidesList: List<RideModel>.from(json["completed_rides_list"].map((x) => RideModel.fromJson(x))),
        unfinishedRidesList: List<RideModel>.from(json["unfinished_rides_list"].map((x) => RideModel.fromJson(x))),
        completedRides: json["completed_rides"] .toString(),
        cancelledRides: json["cancelled_rides"].toString(),
        rejectedRides: json["rejected_rides"].toString(),
        timeoutRides: json["timeout_rides"].toString(),
        earnings: json["earnings"] .toString(),
    );

    Map<String, dynamic> toJson() => {
        "completed_rides_list": List<dynamic>.from(completedRidesList.map((x) => x.toJson())),
        "unfinished_rides_list": List<dynamic>.from(unfinishedRidesList.map((x) => x.toJson())),
        "completed_rides": completedRides,
        "cancelled_rides": cancelledRides,
        "rejected_rides": rejectedRides,
        "timeout_rides": timeoutRides,
        "earnings": earnings,
    };
}

class RideModel {
    RideModel({
        required this.id,
        required this.customerId,
        required this.bookingId,
        required this.fromLocation,
        required this.bookedAt,
        required this.toLocation,
        required this.status,
    });

    String id;
    String customerId;
    String bookingId;
    String fromLocation;
    DateTime bookedAt;
    String toLocation;
    String status;

    factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        id: json["id"] .toString(),
        customerId: json["customer_id"] .toString(),
        bookingId: json["booking_id"] .toString(),
        fromLocation: json["from_location"] .toString(),
        bookedAt: DateTime.parse(json["booked_at"]) ,
        toLocation: json["to_location"] .toString(),
        status: json["status"] .toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "booking_id": bookingId,
        "from_location": fromLocation,
        "booked_at": bookedAt.toIso8601String(),
        "to_location": toLocation,
        "status": status,
    };
}
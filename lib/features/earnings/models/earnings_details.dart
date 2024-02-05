class EarningsDetails {
    EarningsDetails({
        required this.bookingDetails,
        required this.customer,
    });

    BookingDetails bookingDetails;
    Customer customer;

    factory EarningsDetails.fromJson(Map<String, dynamic> json) => EarningsDetails(
        bookingDetails: BookingDetails.fromJson(json["booking_details"]),
        customer: Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "booking_details": bookingDetails.toJson(),
        "customer": customer.toJson(),
    };
}

class BookingDetails {
    BookingDetails({
        required this.id,
        required this.bookingId,
        required this.customerId,
        required this.fromLocation,
        required this.bookedAt,
        required this.toLocation,
        required this.distance,
        required this.fare,
        required this.tax,
        required this.serviceCharge,
        required this.totalFare,
        required this.driverPercent,
        required this.driverFare,
        required this.nightRide,
        required this.paymentStatus,
        this.paymentType,
        required this.startedAt,
        required this.completedAt,
        required this.extraRideFee,
        required this.waitingCharge,
        required this.starRating,
        required this.review,
    });

    int id;
    String bookingId;
    String customerId;
    String fromLocation;
    DateTime bookedAt;
    String toLocation;
    String distance;
    String fare;
    String tax;
    String serviceCharge;
    String totalFare;
    String driverPercent;
    String driverFare;
    String nightRide;
    String paymentStatus;
    dynamic paymentType;
    DateTime startedAt;
    DateTime completedAt;
    String extraRideFee;
    String waitingCharge;
    String? starRating;
    String? review;

    factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        id: json["id"],
        bookingId: json["booking_id"].toString(),
        customerId: json["customer_id"].toString(),
        fromLocation: json["from_location"].toString(),
        bookedAt: DateTime.parse(json["booked_at"]),
        toLocation: json["to_location"].toString(),
        distance: json["distance"].toString(),
        fare: json["fare"].toString(),
        tax: json["tax"].toString(),  
        serviceCharge: json["service_charge"].toString(),
        totalFare: json["total_fare"].toString(),
        driverPercent: json["driver_percent"].toString(),
        driverFare: json["driver_fare"].toString(),
        nightRide: json["night_ride"].toString(),
        paymentStatus: json["payment_status"].toString(),
        paymentType: json["payment_type"],
        startedAt: DateTime.parse(json["started_at"]),
        completedAt: DateTime.parse(json["completed_at"]),
        extraRideFee: json["extra_ride_fee"].toString(),
        waitingCharge: json["waiting_charge"].toString(),
        starRating: json["star_rating"]?.toString(),
        review: json["review"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "customer_id": customerId,
        "from_location": fromLocation,
        "booked_at": bookedAt.toIso8601String(),
        "to_location": toLocation,
        "distance": distance,
        "fare": fare,
        "tax": tax,
        "service_charge": serviceCharge,
        "total_fare": totalFare,
        "driver_percent": driverPercent,
        "driver_fare": driverFare,
        "night_ride": nightRide,
        "payment_status": paymentStatus,
        "payment_type": paymentType,
        "started_at": startedAt.toIso8601String(),
        "completed_at": completedAt.toIso8601String(),
        "extra_ride_fee": extraRideFee,
        "waiting_charge": waitingCharge,
        "star_rating": starRating,
        "review": review,
    };
}

class Customer {
    Customer({
        required this.name,
        required this.mobile,
    });

    String name;
    String mobile;

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        name: json["name"],
        mobile: json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
    };
}

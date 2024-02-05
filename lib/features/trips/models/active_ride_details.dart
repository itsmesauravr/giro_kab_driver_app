class ActiveRideDetails {
    ActiveRideDetails({
        required this.bookingDetails,
        required this.customer,
    });

    BookingDetails bookingDetails;
    Customer customer;

    factory ActiveRideDetails.fromJson(Map<String, dynamic> json) => ActiveRideDetails(
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
        required this.customerId,
        required this.fromLocation,
        required this.toLocation,
        required this.distance,
        required this.fare,
        required this.time,
        required this.tax,
        required this.serviceCharge,
        required this.totalFare,
        required this.nightRide,
        required this.paymentStatus,
        this.paymentType,
        required this.status,
    });

    int id;
    String customerId;
    String fromLocation;
    String toLocation;
    String distance;
    String fare;
    String time;
    String tax;
    String serviceCharge;
    String totalFare;
    String nightRide;
    String paymentStatus;
    dynamic paymentType;
    String status;

    factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        id: json["id"],
        customerId: json["customer_id"].toString(),
        fromLocation: json["from_location"].toString(),
        toLocation: json["to_location"].toString(),
        distance: json["distance"].toString(),
        fare: json["fare"].toString(),
        time: json["time"].toString(),
        tax: json["tax"].toString(),
        serviceCharge: json["service_charge"].toString(),
        totalFare: json["total_fare"].toString(),
        nightRide: json["night_ride"].toString(),
        paymentStatus: json["payment_status"].toString(),
        paymentType: json["payment_type"]?.toString(),
        status: json["status"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "from_location": fromLocation,
        "to_location": toLocation,
        "distance": distance,
        "fare": fare,
        "time": time,
        "tax": tax,
        "service_charge": serviceCharge,
        "total_fare": totalFare,
        "night_ride": nightRide,
        "payment_status": paymentStatus,
        "payment_type": paymentType,
        "status": status,
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

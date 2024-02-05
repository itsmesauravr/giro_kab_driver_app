class ProfileStatus {
    ProfileStatus({
      required  this.profileUploadStatus,
      required  this.profileApprovalStatus,
      required  this.vehicleUploadStatus,
      required  this.vehicleApprovalStatus,
      required  this.rcUploadStatus,
      required  this.rcApprovalStatus,
      required  this.licensefrontUploadStatus,
      required  this.licensefrontApprovalStatus,
      required  this.licensebackUploadStatus,
      required  this.licensebackApprovalStatus,
      required  this.insuranceUploadStatus,
      required  this.insuranceApprovalStatus,
      required  this.pollutionUploadStatus,
      required  this.pollutionApprovalStatus,
      required  this.permitUploadStatus,
      required  this.permitApprovalStatus,
      required  this.paymentStatus,
    });

    String profileUploadStatus;
    String profileApprovalStatus;
    String vehicleUploadStatus;
    String vehicleApprovalStatus;
    String rcUploadStatus;
    String rcApprovalStatus;
    String licensefrontUploadStatus;
    String licensefrontApprovalStatus;
    String licensebackUploadStatus;
    String licensebackApprovalStatus;
    String insuranceUploadStatus;
    String insuranceApprovalStatus;
    String pollutionUploadStatus;
    String pollutionApprovalStatus;
    String permitUploadStatus;
    String permitApprovalStatus;
    String paymentStatus;

    factory ProfileStatus.fromJson(Map<String, dynamic> json) => ProfileStatus(
        profileUploadStatus: json["profile_upload_status"].toString(),
        profileApprovalStatus: json["profile_approval_status"].toString(),
        vehicleUploadStatus: json["vehicle_upload_status"].toString(),
        vehicleApprovalStatus: json["vehicle_approval_status"].toString(),
        rcUploadStatus: json["rc_upload_status"].toString(),
        rcApprovalStatus: json["rc_approval_status"].toString(),
        licensefrontUploadStatus: json["licensefront_upload_status"].toString(),
        licensefrontApprovalStatus: json["licensefront_approval_status"].toString(),
        licensebackUploadStatus: json["licenseback_upload_status"].toString(),
        licensebackApprovalStatus: json["licenseback_approval_status"].toString(),
        insuranceUploadStatus: json["insurance_upload_status"].toString(),
        insuranceApprovalStatus: json["insurance_approval_status"].toString(),
        pollutionUploadStatus: json["pollution_upload_status"].toString(),
        pollutionApprovalStatus: json["pollution_approval_status"].toString(),
        permitUploadStatus: json["permit_upload_status"].toString(),
        permitApprovalStatus: json["permit_approval_status"].toString(),
        paymentStatus: json["payment_status"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "profile_upload_status": profileUploadStatus,
        "profile_approval_status": profileApprovalStatus,
        "vehicle_upload_status": vehicleUploadStatus,
        "vehicle_approval_status": vehicleApprovalStatus,
        "rc_upload_status": rcUploadStatus,
        "rc_approval_status": rcApprovalStatus,
        "licensefront_upload_status": licensefrontUploadStatus,
        "licensefront_approval_status": licensefrontApprovalStatus,
        "licenseback_upload_status": licensebackUploadStatus,
        "licenseback_approval_status": licensebackApprovalStatus,
        "insurance_upload_status": insuranceUploadStatus,
        "insurance_approval_status": insuranceApprovalStatus,
        "pollution_upload_status": pollutionUploadStatus,
        "pollution_approval_status": pollutionApprovalStatus,
        "permit_upload_status": permitUploadStatus,
        "permit_approval_status": permitApprovalStatus,
        "payment_status": paymentStatus,
    };
}
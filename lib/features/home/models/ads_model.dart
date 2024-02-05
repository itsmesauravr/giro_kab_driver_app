class Ads {
    Ads({
        required this.adsDetails,
    });

    List<AdsDetail> adsDetails;

    factory Ads.fromJson(Map<String, dynamic> json) => Ads(
        adsDetails: List<AdsDetail>.from(json["ads_details"].map((x) => AdsDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ads_details": List<dynamic>.from(adsDetails.map((x) => x.toJson())),
    };
}

class AdsDetail {
    AdsDetail({
        required this.id,
        required this.title,
        required this.photo,
    });

    int id;
    String title;
    String photo;

    factory AdsDetail.fromJson(Map<String, dynamic> json) => AdsDetail(
        id: json["id"],
        title: json["title"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "photo": photo,
    };
}

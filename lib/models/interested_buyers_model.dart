// models/interested_buyers_model.dart

class InterestedBuyersModel {
  // Mongo fields
  final String? id; // _id
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // User data
  final String dealerDocId;
  final String dealerPhoneNumber;
  final String dealerRole;
  final String dealerCity;
  final String dealerName;
  final String dealerAssignedPhone;
  final String dealerState;
  final String dealerUserId;
  final String dealerEmail;
  final String dealerUserName;

  // Car data
  final String carDocId;
  final String carContact;
  final String carName;
  final String carDesc;
  final String carPrice;
  final String carYear;
  final String carTaxValidity;
  final String carOwnershipSerialNo;
  final String carMake;
  final String carModel;
  final String carVariant;
  final String carKms;
  final String carTransmission;
  final String carFuelType;
  final String carBodyType;
  final List<CarImageUrl> carImageUrls;

  // Other related data
  final bool isDeleted;
  final DateTime? scrapedAt;
  final DateTime? uploadedAt;

  // Customer app related data
  final String activityType; // "interested"
  final String interestedBuyerId;

  // Extra fields not in mongo model or docs of interestedBuyers collection
  final String? customerPhoneNumber;
  final String? customerUserName;

  const InterestedBuyersModel({
    this.id,
    this.createdAt,
    this.updatedAt,

    // User data
    this.dealerDocId = "",
    this.dealerPhoneNumber = "",
    this.dealerRole = "",
    this.dealerCity = "",
    this.dealerName = "",
    this.dealerAssignedPhone = "",
    this.dealerState = "",
    this.dealerUserId = "",
    this.dealerEmail = "",
    this.dealerUserName = "",

    // Car data
    this.carDocId = "",
    this.carContact = "",
    this.carName = "",
    this.carDesc = "",
    this.carPrice = "",
    this.carYear = "",
    this.carTaxValidity = "",
    this.carOwnershipSerialNo = "",
    this.carMake = "",
    this.carModel = "",
    this.carVariant = "",
    this.carKms = "",
    this.carTransmission = "",
    this.carFuelType = "",
    this.carBodyType = "",
    this.carImageUrls = const [],

    // Other related data
    this.isDeleted = false,
    this.scrapedAt,
    this.uploadedAt,

    // Customer app related data
    this.activityType = "interested",
    this.interestedBuyerId = "",

    // Extra fields not in mongo model or docs of interestedBuyers collection
    this.customerPhoneNumber,
    this.customerUserName,
  });

  factory InterestedBuyersModel.fromJson(Map<String, dynamic> json) {
    return InterestedBuyersModel(
      id: (json["_id"] ?? json["id"])?.toString(),
      createdAt: _tryParseDate(json["createdAt"]),
      updatedAt: _tryParseDate(json["updatedAt"]),

      // User data
      dealerDocId: (json["dealerDocId"] ?? "").toString(),
      dealerPhoneNumber: (json["dealerPhoneNumber"] ?? "").toString(),
      dealerRole: (json["dealerRole"] ?? "").toString(),
      dealerCity: (json["dealerCity"] ?? "").toString(),
      dealerName: (json["dealerName"] ?? "").toString(),
      dealerAssignedPhone: (json["dealerAssignedPhone"] ?? "").toString(),
      dealerState: (json["dealerState"] ?? "").toString(),
      dealerUserId: (json["dealerUserId"] ?? "").toString(),
      dealerEmail: (json["dealerEmail"] ?? "").toString(),
      dealerUserName: (json["dealerUserName"] ?? "").toString(),

      // Car data
      carDocId: (json["carDocId"] ?? "").toString(),
      carContact: (json["carContact"] ?? "").toString(),
      carName: (json["carName"] ?? "").toString(),
      carDesc: (json["carDesc"] ?? "").toString(),
      carPrice: (json["carPrice"] ?? "").toString(),
      carYear: (json["carYear"] ?? "").toString(),
      carTaxValidity: (json["carTaxValidity"] ?? "").toString(),
      carOwnershipSerialNo: (json["carOwnershipSerialNo"] ?? "").toString(),
      carMake: (json["carMake"] ?? "").toString(),
      carModel: (json["carModel"] ?? "").toString(),
      carVariant: (json["carVariant"] ?? "").toString(),
      carKms: (json["carKms"] ?? "").toString(),
      carTransmission: (json["carTransmission"] ?? "").toString(),
      carFuelType: (json["carFuelType"] ?? "").toString(),
      carBodyType: (json["carBodyType"] ?? "").toString(),
      carImageUrls: (json["carImageUrls"] is List)
          ? (json["carImageUrls"] as List)
              .map((e) => CarImageUrl.fromJson((e as Map).cast<String, dynamic>()))
              .toList()
          : const [],

      // Other related data
      isDeleted: json["isDeleted"] == true,
      scrapedAt: _tryParseDate(json["scrapedAt"]),
      uploadedAt: _tryParseDate(json["uploadedAt"]),

      // Customer app related data
      activityType: (json["activityType"] ?? "interested").toString(),
      interestedBuyerId: (json["interestedBuyerId"] ?? "").toString(),

      // Extra fields not in mongo model or docs of interestedBuyers collection
      customerPhoneNumber: (json["customerPhoneNumber"] ?? "").toString(),
      customerUserName: (json["customerUserName"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "dealerDocId": dealerDocId,
      "dealerPhoneNumber": dealerPhoneNumber,
      "dealerRole": dealerRole,
      "dealerCity": dealerCity,
      "dealerName": dealerName,
      "dealerAssignedPhone": dealerAssignedPhone,
      "dealerState": dealerState,
      "dealerUserId": dealerUserId,
      "dealerEmail": dealerEmail,
      "dealerUserName": dealerUserName,

      "carDocId": carDocId,
      "carContact": carContact,
      "carName": carName,
      "carDesc": carDesc,
      "carPrice": carPrice,
      "carYear": carYear,
      "carTaxValidity": carTaxValidity,
      "carOwnershipSerialNo": carOwnershipSerialNo,
      "carMake": carMake,
      "carModel": carModel,
      "carVariant": carVariant,
      "carKms": carKms,
      "carTransmission": carTransmission,
      "carFuelType": carFuelType,
      "carBodyType": carBodyType,
      "carImageUrls": carImageUrls.map((e) => e.toJson()).toList(),

      "isDeleted": isDeleted,
      "scrapedAt": scrapedAt?.toIso8601String(),
      "uploadedAt": uploadedAt?.toIso8601String(),

      "activityType": activityType,
      "interestedBuyerId": interestedBuyerId,

      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  InterestedBuyersModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,

    String? dealerDocId,
    String? dealerPhoneNumber,
    String? dealerRole,
    String? dealerCity,
    String? dealerName,
    String? dealerAssignedPhone,
    String? dealerState,
    String? dealerUserId,
    String? dealerEmail,
    String? dealerUserName,

    String? carDocId,
    String? carContact,
    String? carName,
    String? carDesc,
    String? carPrice,
    String? carYear,
    String? carTaxValidity,
    String? carOwnershipSerialNo,
    String? carMake,
    String? carModel,
    String? carVariant,
    String? carKms,
    String? carTransmission,
    String? carFuelType,
    String? carBodyType,
    List<CarImageUrl>? carImageUrls,

    bool? isDeleted,
    DateTime? scrapedAt,
    DateTime? uploadedAt,

    String? activityType,
    String? interestedBuyerId,
  }) {
    return InterestedBuyersModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      dealerDocId: dealerDocId ?? this.dealerDocId,
      dealerPhoneNumber: dealerPhoneNumber ?? this.dealerPhoneNumber,
      dealerRole: dealerRole ?? this.dealerRole,
      dealerCity: dealerCity ?? this.dealerCity,
      dealerName: dealerName ?? this.dealerName,
      dealerAssignedPhone: dealerAssignedPhone ?? this.dealerAssignedPhone,
      dealerState: dealerState ?? this.dealerState,
      dealerUserId: dealerUserId ?? this.dealerUserId,
      dealerEmail: dealerEmail ?? this.dealerEmail,
      dealerUserName: dealerUserName ?? this.dealerUserName,

      carDocId: carDocId ?? this.carDocId,
      carContact: carContact ?? this.carContact,
      carName: carName ?? this.carName,
      carDesc: carDesc ?? this.carDesc,
      carPrice: carPrice ?? this.carPrice,
      carYear: carYear ?? this.carYear,
      carTaxValidity: carTaxValidity ?? this.carTaxValidity,
      carOwnershipSerialNo: carOwnershipSerialNo ?? this.carOwnershipSerialNo,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      carVariant: carVariant ?? this.carVariant,
      carKms: carKms ?? this.carKms,
      carTransmission: carTransmission ?? this.carTransmission,
      carFuelType: carFuelType ?? this.carFuelType,
      carBodyType: carBodyType ?? this.carBodyType,
      carImageUrls: carImageUrls ?? this.carImageUrls,

      isDeleted: isDeleted ?? this.isDeleted,
      scrapedAt: scrapedAt ?? this.scrapedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,

      activityType: activityType ?? this.activityType,
      interestedBuyerId: interestedBuyerId ?? this.interestedBuyerId,
    );
  }

  static DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    final s = v.toString();
    if (s.isEmpty || s == "null") return null;
    return DateTime.tryParse(s);
  }
}

class CarImageUrl {
  final String path;
  final bool status;
  final String url;

  const CarImageUrl({
    this.path = "",
    this.status = false,
    this.url = "",
  });

  factory CarImageUrl.fromJson(Map<String, dynamic> json) {
    return CarImageUrl(
      path: (json["path"] ?? "").toString(),
      status: json["status"] == true,
      url: (json["url"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "path": path,
      "status": status,
      "url": url,
    };
  }

  CarImageUrl copyWith({
    String? path,
    bool? status,
    String? url,
  }) {
    return CarImageUrl(
      path: path ?? this.path,
      status: status ?? this.status,
      url: url ?? this.url,
    );
  }
}

class InspectionRequestsModel {
  String? id;
  String? carRegistrationNumber;
  String? ownerName;
  String? carMakeModelVariant;
  String? yearOfRegistration;
  String? ownershipSerialNumber;
  List<String>? carImages;
  DateTime? inspectionDateTime;
  String? inspectionAddress;
  DateTime? createdAt;
  DateTime? updatedAt;

  InspectionRequestsModel({
    this.id,
    this.carRegistrationNumber,
    this.ownerName,
    this.carMakeModelVariant,
    this.yearOfRegistration,
    this.ownershipSerialNumber,
    this.carImages,
    this.inspectionDateTime,
    this.inspectionAddress,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON to Dart object
  factory InspectionRequestsModel.fromJson(Map<String, dynamic> json) {
    return InspectionRequestsModel(
      id: json['_id'] ?? '',
      carRegistrationNumber: json['carRegistrationNumber'],
      ownerName: json['ownerName'],
      carMakeModelVariant: json['carMakeModelVariant'],
      yearOfRegistration: json['yearOfRegistration'],
      ownershipSerialNumber: json['ownershipSerialNumber'],
      carImages: json['carImages'] != null
          ? List<String>.from(json['carImages'])
          : null,
      inspectionDateTime: json['inspectionDateTime'] != null
          ? DateTime.parse(json['inspectionDateTime'])
          : null,
      inspectionAddress: json['inspectionAddress'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'carRegistrationNumber': carRegistrationNumber,
      'ownerName': ownerName,
      'carMakeModelVariant': carMakeModelVariant,
      'yearOfRegistration': yearOfRegistration,
      'ownershipSerialNumber': ownershipSerialNumber,
      'carImages': carImages,
      'inspectionDateTime': inspectionDateTime?.toIso8601String(),
      'inspectionAddress': inspectionAddress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

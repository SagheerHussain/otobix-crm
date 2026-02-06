class TelecallingLogChange {
  String? field;
  dynamic from;
  dynamic to;

  TelecallingLogChange({
    this.field,
    this.from,
    this.to,
  });

  factory TelecallingLogChange.fromJson(Map<String, dynamic> json) {
    return TelecallingLogChange(
      field: json['field'],
      from: json['from'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'from': from,
      'to': to,
    };
  }
}

class TelecallingLog {
  DateTime? changedAt;
  String? changedBy;
  String? source;
  List<TelecallingLogChange>? changes;

  TelecallingLog({
    this.changedAt,
    this.changedBy,
    this.source,
    this.changes,
  });

  factory TelecallingLog.fromJson(Map<String, dynamic> json) {
    return TelecallingLog(
      changedAt:
          json['changedAt'] != null ? DateTime.parse(json['changedAt']) : null,
      changedBy: json['changedBy'],
      source: json['source'],
      changes: json['changes'] != null
          ? (json['changes'] as List)
              .map((e) =>
                  TelecallingLogChange.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'changedAt': changedAt?.toIso8601String(),
      'changedBy': changedBy,
      'source': source,
      'changes': changes?.map((e) => e.toJson()).toList(),
    };
  }
}

class TelecallingModel {
  String? id; // Mongo _id
  String? appointmentId;

  // REQUIRED business fields
  String? carRegistrationNumber;
  String? yearOfRegistration;
  String? ownerName;
  int? ownershipSerialNumber;
  String? make;
  String? model;
  String? variant;

  // defaults / optional fields
  DateTime? timeStamp;

  String? emailAddress;
  String? appointmentSource;
  String? vehicleStatus;
  String? zipCode;
  String? customerContactNumber;
  String? city;

  String? yearOfManufacture;

  String? allocatedTo;
  String? inspectionStatus;
  String? approvalStatus;
  String? priority;
  String? ncdUcdName;
  String? repName;
  String? repContact;
  String? bankSource;
  String? referenceName;
  String? remarks;
  String? createdBy;

  int? odometerReadingInKms;
  String? additionalNotes;
  List<String>? carImages;

  DateTime? inspectionDateTime;
  String? inspectionAddress;
  String? inspectionEngineerNumber;

  String? addedBy; // "Customer" | "Telecaller"

  List<TelecallingLog>? logs;

  DateTime? createdAt;
  DateTime? updatedAt;

  TelecallingModel({
    this.id,
    this.appointmentId,
    this.carRegistrationNumber,
    this.yearOfRegistration,
    this.ownerName,
    this.ownershipSerialNumber,
    this.make,
    this.model,
    this.variant,
    this.timeStamp,
    this.emailAddress,
    this.appointmentSource,
    this.vehicleStatus,
    this.zipCode,
    this.customerContactNumber,
    this.city,
    this.yearOfManufacture,
    this.allocatedTo,
    this.inspectionStatus,
    this.approvalStatus,
    this.priority,
    this.ncdUcdName,
    this.repName,
    this.repContact,
    this.bankSource,
    this.referenceName,
    this.remarks,
    this.createdBy,
    this.odometerReadingInKms,
    this.additionalNotes,
    this.carImages,
    this.inspectionDateTime,
    this.inspectionAddress,
    this.inspectionEngineerNumber,
    this.addedBy,
    this.logs,
    this.createdAt,
    this.updatedAt,
  });

  factory TelecallingModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString());
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return TelecallingModel(
      id: (json['_id'] ?? '').toString(),
      appointmentId: json['appointmentId']?.toString(),
      carRegistrationNumber: json['carRegistrationNumber'],
      yearOfRegistration: json['yearOfRegistration'],
      ownerName: json['ownerName'],
      ownershipSerialNumber: parseInt(json['ownershipSerialNumber']),
      make: json['make'],
      model: json['model'],
      variant: json['variant'],
      timeStamp: parseDate(json['timeStamp']),
      emailAddress: json['emailAddress'],
      appointmentSource: json['appointmentSource'],
      vehicleStatus: json['vehicleStatus'],
      zipCode: json['zipCode'],
      customerContactNumber: json['customerContactNumber'],
      city: json['city'],
      yearOfManufacture: json['yearOfManufacture'],
      allocatedTo: json['allocatedTo'],
      inspectionStatus: json['inspectionStatus'],
      approvalStatus: json['approvalStatus'],
      priority: json['priority'],
      ncdUcdName: json['ncdUcdName'],
      repName: json['repName'],
      repContact: json['repContact'],
      bankSource: json['bankSource'],
      referenceName: json['referenceName'],
      remarks: json['remarks'],
      createdBy: json['createdBy'],
      odometerReadingInKms: parseInt(json['odometerReadingInKms']),
      additionalNotes: json['additionalNotes'],
      carImages: json['carImages'] != null
          ? List<String>.from(json['carImages'])
          : <String>[],
      inspectionDateTime: parseDate(json['inspectionDateTime']),
      inspectionAddress: json['inspectionAddress'],
      inspectionEngineerNumber: json['inspectionEngineerNumber'],
      addedBy: json['addedBy'],
      logs: json['logs'] != null
          ? (json['logs'] as List)
              .map((e) => TelecallingLog.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'appointmentId': appointmentId,
      'carRegistrationNumber': carRegistrationNumber,
      'yearOfRegistration': yearOfRegistration,
      'ownerName': ownerName,
      'ownershipSerialNumber': ownershipSerialNumber,
      'make': make,
      'model': model,
      'variant': variant,
      'timeStamp': timeStamp?.toIso8601String(),
      'emailAddress': emailAddress,
      'appointmentSource': appointmentSource,
      'vehicleStatus': vehicleStatus,
      'zipCode': zipCode,
      'customerContactNumber': customerContactNumber,
      'city': city,
      'yearOfManufacture': yearOfManufacture,
      'allocatedTo': allocatedTo,
      'inspectionStatus': inspectionStatus,
      'approvalStatus': approvalStatus,
      'priority': priority,
      'ncdUcdName': ncdUcdName,
      'repName': repName,
      'repContact': repContact,
      'bankSource': bankSource,
      'referenceName': referenceName,
      'remarks': remarks,
      'createdBy': createdBy,
      'odometerReadingInKms': odometerReadingInKms,
      'additionalNotes': additionalNotes,
      'carImages': carImages ?? [],
      'inspectionDateTime': inspectionDateTime?.toIso8601String(),
      'inspectionAddress': inspectionAddress,
      'inspectionEngineerNumber': inspectionEngineerNumber,
      'addedBy': addedBy,
      'logs': logs?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

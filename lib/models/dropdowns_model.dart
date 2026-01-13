class DropdownsModel {
  final String? id;
  final String dropdownName;
  final List<String> dropdownValues;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DropdownsModel({
    this.id,
    required this.dropdownName,
    required this.dropdownValues,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory DropdownsModel.fromJson(Map<String, dynamic> json) {
    // handle _id either as string or as { "$oid": "..." }
    String? parseId(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map && value["\$oid"] != null) {
        return value["\$oid"].toString();
      }
      return value.toString();
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      if (value is Map && value["\$date"] != null) {
        return DateTime.tryParse(value["\$date"].toString());
      }
      return null;
    }

    return DropdownsModel(
      id: parseId(json["_id"]),
      dropdownName: (json["dropdownName"] ?? "").toString(),
      dropdownValues: (json["dropdownValues"] is List)
          ? (json["dropdownValues"] as List).map((e) => e.toString()).toList()
          : <String>[],
      isActive: json["isActive"] is bool ? json["isActive"] as bool : true,
      createdAt: parseDate(json["createdAt"]),
      updatedAt: parseDate(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "dropdownName": dropdownName,
      "dropdownValues": dropdownValues,
      "isActive": isActive,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

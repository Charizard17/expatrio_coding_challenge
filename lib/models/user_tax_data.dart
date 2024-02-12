class UserTaxData {
  final TaxResidence primaryTaxResidence;
  final List<TaxResidence>? secondaryTaxResidences;

  UserTaxData({
    required this.primaryTaxResidence,
    this.secondaryTaxResidences,
  });

  factory UserTaxData.fromJson(Map<String, dynamic> json) {
    return UserTaxData(
      primaryTaxResidence: TaxResidence.fromJson(json['primaryTaxResidence']),
      secondaryTaxResidences: (json['secondaryTaxResidence'] as List<dynamic>?)
          ?.map((residence) => TaxResidence.fromJson(residence))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryTaxResidence': primaryTaxResidence.toJson(),
      'secondaryTaxResidence': secondaryTaxResidences
          ?.map((residence) => residence.toJson())
          .toList(),
    };
  }

  UserTaxData copyWith({
    TaxResidence? primaryTaxResidence,
    List<TaxResidence>? secondaryTaxResidences,
  }) {
    return UserTaxData(
      primaryTaxResidence: primaryTaxResidence ?? this.primaryTaxResidence,
      secondaryTaxResidences:
          secondaryTaxResidences ?? this.secondaryTaxResidences,
    );
  }
}

class TaxResidence {
  final String countryCode;
  final String id;

  TaxResidence({
    required this.countryCode,
    required this.id,
  });

  factory TaxResidence.fromJson(Map<String, dynamic> json) {
    return TaxResidence(
      countryCode: json['country'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': countryCode,
      'id': id,
    };
  }
}

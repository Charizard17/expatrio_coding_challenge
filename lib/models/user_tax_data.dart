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
}

class TaxResidence {
  final String country;
  final String id;

  TaxResidence({
    required this.country,
    required this.id,
  });

  factory TaxResidence.fromJson(Map<String, dynamic> json) {
    return TaxResidence(
      country: json['country'] as String,
      id: json['id'] as String,
    );
  }
}

import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:flutter/material.dart';
import 'package:expatrio_coding_challenge/models/user_tax_data.dart';

class UserTaxDataProvider extends ChangeNotifier {
  UserTaxData? _userTaxData;

  UserTaxData? get userTaxData => _userTaxData;

  Future<void> updateUserTaxData(int userId, String accessToken) async {
    try {
      final UserTaxData userTaxData =
          await ExpatrioApiService().getUserTaxData(userId, accessToken);
      _userTaxData = userTaxData;
      notifyListeners();
    } catch (e) {
      Exception('Error fetching user tax data: $e');
    }
  }

  void updatePrimaryTaxResidenceCountry(String country) {
    if (_userTaxData != null) {
      final updatedPrimaryTaxResidence = TaxResidence(
        id: _userTaxData!.primaryTaxResidence.id,
        countryCode: country,
      );

      _userTaxData = _userTaxData!.copyWith(
        primaryTaxResidence: updatedPrimaryTaxResidence,
      );

      notifyListeners();
    }
  }

  void updateSecondaryTaxResidences(
      TaxResidence previousResidence, String updatedCountryCode) {
    if (_userTaxData != null) {
      final updatedSecondaryResidences =
          _userTaxData!.secondaryTaxResidences?.map((residence) {
        if (residence == previousResidence) {
          return TaxResidence(
            id: residence.id,
            countryCode: updatedCountryCode,
          );
        } else {
          return residence;
        }
      }).toList();

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  void updatePrimaryTaxId(String newTaxId) {
    if (_userTaxData != null) {
      final updatedPrimaryTaxResidence = TaxResidence(
        id: newTaxId,
        countryCode: _userTaxData!.primaryTaxResidence.countryCode,
      );

      _userTaxData = _userTaxData!.copyWith(
        primaryTaxResidence: updatedPrimaryTaxResidence,
      );

      notifyListeners();
    }
  }

  void updateSecondaryTaxId(TaxResidence residence, String newTaxId) {
    if (_userTaxData != null) {
      final updatedSecondaryResidences =
          _userTaxData!.secondaryTaxResidences?.map((existingResidence) {
        if (existingResidence == residence) {
          return TaxResidence(
            id: newTaxId,
            countryCode: existingResidence.countryCode,
          );
        } else {
          return existingResidence;
        }
      }).toList();

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  List<String> getSelectedCountryCodes() {
    final List<String> countryCodes = [];

    if (_userTaxData != null) {
      countryCodes.add(_userTaxData!.primaryTaxResidence.countryCode);

      if (_userTaxData!.secondaryTaxResidences != null) {
        for (var residence in _userTaxData!.secondaryTaxResidences!) {
          countryCodes.add(residence.countryCode);
        }
      }
    }

    return countryCodes;
  }
}

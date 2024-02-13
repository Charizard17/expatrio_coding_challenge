import 'package:expatrio_coding_challenge/models/user_tax_data.dart';
import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:flutter/material.dart';

class UserTaxDataProvider extends ChangeNotifier {
  UserTaxData? _userTaxData;

  UserTaxData? get userTaxData => _userTaxData;

  set userTaxData(UserTaxData? newUserTaxData) {
    _userTaxData = newUserTaxData;
    notifyListeners();
  }

  Future<void> updateUserTaxData(int userId, String accessToken) async {
    try {
      final UserTaxData userTaxData = await ExpatrioApiService().getUserTaxData(
        userId: userId,
        accessToken: accessToken,
      );
      _userTaxData = userTaxData;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user tax data: $e');
    }
  }

  void updatePrimaryTaxResidenceCountry(String country) {
    if (_userTaxData != null) {
      final updatedPrimaryTaxResidence =
          _userTaxData!.primaryTaxResidence.copyWith(
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
        return residence == previousResidence
            ? residence.copyWith(countryCode: updatedCountryCode)
            : residence;
      }).toList();

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  void updatePrimaryTaxId(String newTaxId) {
    if (_userTaxData != null) {
      final updatedPrimaryTaxResidence =
          _userTaxData!.primaryTaxResidence.copyWith(
        id: newTaxId,
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
        return existingResidence == residence
            ? existingResidence.copyWith(id: newTaxId)
            : existingResidence;
      }).toList();

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  void addSecondaryTaxResidence() {
    if (_userTaxData != null) {
      final newResidence = TaxResidence(countryCode: '', id: '');
      final updatedSecondaryResidences = List<TaxResidence>.from(
        _userTaxData!.secondaryTaxResidences ?? [],
      )..add(newResidence);

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  void removeSecondaryTaxResidence(TaxResidence residenceToRemove) {
    if (_userTaxData != null) {
      final updatedSecondaryResidences =
          _userTaxData!.secondaryTaxResidences?.where((residence) {
        return residence != residenceToRemove;
      }).toList();

      _userTaxData = _userTaxData!.copyWith(
        secondaryTaxResidences: updatedSecondaryResidences,
      );

      notifyListeners();
    }
  }

  bool isTaxResidenceDataEmpty() {
    if (_userTaxData != null) {
      if (_userTaxData!.primaryTaxResidence.countryCode.isEmpty ||
          _userTaxData!.primaryTaxResidence.id.isEmpty) {
        return true;
      }

      return _userTaxData!.secondaryTaxResidences?.any((residence) =>
              residence.countryCode.isEmpty || residence.id.isEmpty) ??
          false;
    }
    return false;
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

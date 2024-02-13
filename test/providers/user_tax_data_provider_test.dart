import 'package:flutter_test/flutter_test.dart';
import 'package:expatrio_coding_challenge/models/user_tax_data.dart';
import 'package:expatrio_coding_challenge/providers/user_tax_data_provider.dart';

void main() {
  group('UserTaxDataProvider', () {
    test('updatePrimaryTaxResidenceCountry', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'US', id: '123'),
      );

      provider.userTaxData = originalData;
      provider.updatePrimaryTaxResidenceCountry('CA');

      expect(provider.userTaxData?.primaryTaxResidence.countryCode, 'CA');
    });

    test('updateSecondaryTaxResidences', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'FR', id: '745'),
        secondaryTaxResidences: [
          TaxResidence(countryCode: 'US', id: '123'),
          TaxResidence(countryCode: 'CA', id: '456'),
        ],
      );

      provider.userTaxData = originalData;
      provider.updateSecondaryTaxResidences(
          originalData.secondaryTaxResidences![0], 'FR');

      expect(
          provider.userTaxData?.secondaryTaxResidences?[0].countryCode, 'FR');
    });

    test('updatePrimaryTaxId', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'US', id: '123'),
      );

      provider.userTaxData = originalData;
      provider.updatePrimaryTaxId('456');

      expect(provider.userTaxData?.primaryTaxResidence.id, '456');
    });

    test('updateSecondaryTaxId', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'FR', id: '745'),
        secondaryTaxResidences: [
          TaxResidence(countryCode: 'US', id: '123'),
          TaxResidence(countryCode: 'CA', id: '456'),
        ],
      );

      provider.userTaxData = originalData;
      provider.updateSecondaryTaxId(
          originalData.secondaryTaxResidences![0], '789');

      expect(provider.userTaxData?.secondaryTaxResidences?[0].id, '789');
    });

    test('addSecondaryTaxResidence', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'FR', id: '745'),
      );

      provider.userTaxData = originalData;
      provider.addSecondaryTaxResidence();

      expect(provider.userTaxData?.secondaryTaxResidences?.length, 1);
    });

    test('removeSecondaryTaxResidence', () {
      final provider = UserTaxDataProvider();
      final originalData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'FR', id: '745'),
        secondaryTaxResidences: [
          TaxResidence(countryCode: 'US', id: '123'),
          TaxResidence(countryCode: 'CA', id: '456'),
        ],
      );

      provider.userTaxData = originalData;
      provider
          .removeSecondaryTaxResidence(originalData.secondaryTaxResidences![0]);

      expect(provider.userTaxData?.secondaryTaxResidences?.length, 1);
    });

    test('isTaxResidenceDataEmpty', () {
      final provider = UserTaxDataProvider();
      final emptyData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: '', id: ''),
      );
      final filledData = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'US', id: '123'),
      );

      provider.userTaxData = emptyData;
      expect(provider.isTaxResidenceDataEmpty(), true);

      provider.userTaxData = filledData;
      expect(provider.isTaxResidenceDataEmpty(), false);
    });

    test('getSelectedCountryCodes', () {
      final provider = UserTaxDataProvider();
      final data = UserTaxData(
        primaryTaxResidence: TaxResidence(countryCode: 'US', id: '123'),
        secondaryTaxResidences: [
          TaxResidence(countryCode: 'CA', id: '456'),
          TaxResidence(countryCode: 'FR', id: '789'),
        ],
      );

      provider.userTaxData = data;
      final countryCodes = provider.getSelectedCountryCodes();

      expect(countryCodes, ['US', 'CA', 'FR']);
    });
  });
}

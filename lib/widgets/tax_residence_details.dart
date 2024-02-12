import 'package:expatrio_coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';

class TaxResidenceDetails extends StatelessWidget {
  final bool isPrimary;
  final String? countryCode;
  final List<String> selectedCountryCodes;
  final void Function(String?)? onCountryChanged;
  final String taxId;
  final void Function(String)? onTaxIdChanged;

  const TaxResidenceDetails({
    Key? key,
    required this.isPrimary,
    this.countryCode,
    required this.selectedCountryCodes,
    this.onCountryChanged,
    required this.taxId,
    this.onTaxIdChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPrimary
              ? 'WHICH COUNTRY SERVES AS YOUR PRIMARY TAX RESIDENCE?*'
              : 'DO YOU HAVE OTHER TAX RESIDENCES?*',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomSheet(context);
              },
            ).then((selectedCountry) {
              if (selectedCountry != null) {
                onCountryChanged?.call(selectedCountry);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  countryCode != null
                      ? CountriesConstants.getCountryLabelFromCode(countryCode!)
                      : 'Select Country',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'TAX IDENTIFICATION NUMBER*',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            initialValue: taxId,
            onChanged: onTaxIdChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final List<String> countries = CountriesConstants.getCountryLabels(
      selectedCountryCodes,
    );
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.teal,
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              'Country',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              onChanged: (value) {
                // Implement search logic here
              },
              decoration: const InputDecoration(
                labelText: 'Search for country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: countries.length,
              itemBuilder: (BuildContext context, int index) {
                final country = countries[index];
                return ListTile(
                  title: Text(country),
                  onTap: () {
                    Navigator.pop(context, country);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

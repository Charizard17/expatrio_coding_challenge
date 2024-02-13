import 'package:expatrio_coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';

class TaxResidenceDetails extends StatelessWidget {
  final bool isPrimary;
  final String? countryCode;
  final List<String> selectedCountryCodes;
  final void Function(String?)? onCountryChanged;
  final String taxId;
  final void Function(String)? onTaxIdChanged;
  final void Function()? onTaxResidenceRemoved;

  const TaxResidenceDetails({
    Key? key,
    required this.isPrimary,
    this.countryCode,
    required this.selectedCountryCodes,
    this.onCountryChanged,
    required this.taxId,
    this.onTaxIdChanged,
    this.onTaxResidenceRemoved,
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
                  CountriesConstants.getCountryLabelFromCode(countryCode!),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (countryCode == '')
          const Column(
            children: [
              Text(
                'Select Tax Residence',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
            ],
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
            decoration: InputDecoration(
              hintText: 'Tax ID or N/A',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        if (taxId == '')
          const Column(
            children: [
              Text(
                'Enter Tax ID',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        if (isPrimary) const SizedBox(height: 20),
        if (!isPrimary)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onTaxResidenceRemoved,
              child: const Text(
                '- REMOVE',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final List<String> countries = CountriesConstants.getCountryLabels(
      selectedCountryCodes,
    );

    List<String> filteredList = countries;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
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
                  setState(() {
                    filteredList = countries
                        .where((country) =>
                            country.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
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
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  final country = filteredList[index];
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
        );
      }),
    );
  }
}

import 'package:expatrio_coding_challenge/providers/user_tax_data_provider.dart';
import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:expatrio_coding_challenge/shared/countries_constants.dart';
import 'package:expatrio_coding_challenge/widgets/tax_residence_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  final int userId;
  final String accessToken;
  final ExpatrioApiService apiService;

  const AccountPage({
    Key? key,
    required this.userId,
    required this.accessToken,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/CryingGirl.svg',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Uh-Oh!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 180,
                child: Text(
                  'We need your tax data in order to access your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _openBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'UPDATE YOUR TAX DATA',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Provider.of<UserTaxDataProvider>(context, listen: false)
            .updateUserTaxData(userId, accessToken);

        return Consumer<UserTaxDataProvider>(
          builder: (context, userTaxDataModel, _) {
            if (userTaxDataModel.userTaxData == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _buildBottomSheet(context, userTaxDataModel);
            }
          },
        );
      },
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    UserTaxDataProvider userTaxDataModel,
  ) {
    final userTaxData = userTaxDataModel.userTaxData!;
    bool isCheckboxChecked = false;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Declaration of Financial Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TaxResidenceDetails(
                  isPrimary: true,
                  countryCode: userTaxData.primaryTaxResidence.countryCode,
                  selectedCountryCodes:
                      userTaxDataModel.getSelectedCountryCodes(),
                  onCountryChanged: (value) {
                    final String countryCode =
                        CountriesConstants.getCountryCodeFromLabel(value!);
                    userTaxDataModel
                        .updatePrimaryTaxResidenceCountry(countryCode);
                  },
                  taxId: userTaxData.primaryTaxResidence.id,
                  onTaxIdChanged: (value) {
                    userTaxDataModel.updatePrimaryTaxId(value);
                  },
                ),
                if (userTaxData.secondaryTaxResidences != null &&
                    userTaxData.secondaryTaxResidences!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var residence in userTaxData.secondaryTaxResidences!)
                        TaxResidenceDetails(
                          isPrimary: false,
                          countryCode: residence.countryCode,
                          selectedCountryCodes:
                              userTaxDataModel.getSelectedCountryCodes(),
                          onCountryChanged: (value) {
                            final String countryCode =
                                CountriesConstants.getCountryCodeFromLabel(
                                    value!);
                            userTaxDataModel.updateSecondaryTaxResidences(
                              residence,
                              countryCode,
                            );
                          },
                          onTaxResidenceRemoved: () {
                            userTaxDataModel.removeSecondaryTaxResidence(
                              residence,
                            );
                          },
                          taxId: residence.id,
                          onTaxIdChanged: (value) {
                            userTaxDataModel.updateSecondaryTaxId(
                              residence,
                              value,
                            );
                          },
                        ),
                    ],
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      userTaxDataModel.addSecondaryTaxResidence();
                    },
                    child: const Text(
                      '+ ADD ANOTHER',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (userTaxDataModel.isTaxResidenceDataEmpty())
                  const Column(children: [
                    Text(
                      "PLEASE CHECK ALL TAX RESIDENCES AND IDS",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 20),
                  ]),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckboxChecked,
                      side: BorderSide(
                        color: isCheckboxChecked ? Colors.teal : Colors.red,
                      ),
                      onChanged: (value) {
                        setState(() {
                          isCheckboxChecked = value!;
                        });
                      },
                      activeColor: Colors.teal,
                      checkColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 260,
                      child: Text(
                        'I confirm above tax residency and US self-declaration is true and accurate.',
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isCheckboxChecked &&
                        !(userTaxDataModel.isTaxResidenceDataEmpty())) {
                      apiService
                          .updateTaxData(
                            userId: userId,
                            accessToken: accessToken,
                            updatedTaxData: userTaxDataModel.userTaxData!,
                          )
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(150, 35),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
  }
}

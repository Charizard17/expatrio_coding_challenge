import 'package:expatrio_coding_challenge/models/user_tax_data.dart';
import 'package:flutter/material.dart';
import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:flutter_svg/svg.dart';

class AccountPage extends StatelessWidget {
  final int userId;
  final String accessToken;

  const AccountPage({
    Key? key,
    required this.userId,
    required this.accessToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
      ),
      body: Container(
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
                _openBottomSheet(
                  context,
                  userId,
                  accessToken,
                );
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
    );
  }

  void _openBottomSheet(
    BuildContext context,
    int userId,
    String accessToken,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<UserTaxData>(
          future: ExpatrioApiService().getUserTaxData(
            userId,
            accessToken,
          ),
          builder: (BuildContext context, AsyncSnapshot<UserTaxData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                final primaryTaxResidence = snapshot.data!.primaryTaxResidence;
                final secondaryTaxResidences =
                    snapshot.data!.secondaryTaxResidences;

                return FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          'Declaration of Financial Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Primary Tax Residence:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Country: ${primaryTaxResidence.country}',
                        ),
                        Text(
                          'ID: ${primaryTaxResidence.id}',
                        ),
                        const SizedBox(height: 10),
                        if (secondaryTaxResidences != null &&
                            secondaryTaxResidences.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Secondary Tax Residences:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              for (var residence in secondaryTaxResidences)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Country: ${residence.country}',
                                    ),
                                    Text(
                                      'ID: ${residence.id}',
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const SizedBox();
              }
            }
          },
        );
      },
    );
  }
}

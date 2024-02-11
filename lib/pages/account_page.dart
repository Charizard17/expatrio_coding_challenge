import 'package:flutter/material.dart';
import 'package:expatrio_coding_challenge/models/account_info.dart';
import 'package:flutter_svg/svg.dart'; // Import the AccountInfo model

class AccountPage extends StatelessWidget {
  final AccountInfo accountInfo; // Define a property to hold the account info

  const AccountPage({Key? key, required this.accountInfo})
      : super(key: key); // Constructor to receive the account info

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
              onPressed: () {},
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
}

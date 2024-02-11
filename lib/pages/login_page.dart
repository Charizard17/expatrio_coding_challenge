import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:expatrio_coding_challenge/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final ExpatrioApiService apiService;
  const LoginPage({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.4,
                  child: LottieBuilder.asset('assets/login-background.json'),
                ),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  'assets/2019_XP_logo_white.png',
                  height: 60,
                ),
                const SizedBox(height: 20),
                LoginForm(
                  apiService: apiService,
                ),
                Expanded(child: Container()),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // help functionality
                        debugPrint('Help button clicked');
                      },
                      icon: const Icon(
                        Icons.help_outline,
                        color: Colors.teal,
                      ),
                      label: const Text(
                        'Help',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

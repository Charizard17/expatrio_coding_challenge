import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:expatrio_coding_challenge/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpatrioApiService apiService = ExpatrioApiService();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        canvasColor: Colors.transparent,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromRGBO(65, 171, 158, 1),
          selectionColor: Color.fromRGBO(65, 171, 158, 1),
          selectionHandleColor: Color.fromRGBO(65, 171, 158, 1),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(Colors.white),
        ).copyWith(
          secondary: createMaterialColor(const Color.fromRGBO(65, 171, 158, 1)),
        ),
        primaryColorDark: Colors.white,
      ),
      home: LoginPage(
        apiService: apiService,
      ),
    );
  }
}

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
                child: LottieBuilder.asset('assets/login-background.json'),
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
                        // login functionality
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

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

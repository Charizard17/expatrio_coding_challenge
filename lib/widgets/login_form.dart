import 'package:expatrio_coding_challenge/models/account_info.dart';
import 'package:expatrio_coding_challenge/pages/account_page.dart';
import 'package:expatrio_coding_challenge/services/expatrio_api_service.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.apiService}) : super(key: key);

  final ExpatrioApiService apiService;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController =
      TextEditingController(text: 'tito+bs792@expatrio.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'nemampojma');

  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final AccountInfo accountInfo =
          await widget.apiService.login(email, password);

      _showLoginSuccessBottomSheet(accountInfo);
    } catch (e) {
      _showLoginErrorBottomSheet(e.toString());

      debugPrint('login failed');
    }
  }

  void _showLoginSuccessBottomSheet(AccountInfo accountInfo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.teal,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Successfull Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'You will be redirected to your dashboard',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountPage(accountInfo: accountInfo),
                      ),
                    );
                  },
                  child: const Text('GOT IT'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showLoginErrorBottomSheet(String errorMessage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.orange,
                size: 70,
              ),
              const SizedBox(height: 10),
              const Text(
                'Invalid Credentials',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('GOT IT'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.email_outlined),
              SizedBox(width: 10),
              Text(
                'EMAIL ADDRESS',
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'john.doe@mail.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.lock_outlined),
              SizedBox(width: 10),
              Text(
                'PASSWORD',
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            obscureText: _isObscured,
            decoration: InputDecoration(
              hintText: '********',
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.teal,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.teal),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

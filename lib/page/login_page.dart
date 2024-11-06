import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:messager/api/http_server.dart';
import 'package:messager/db/user_dao.dart';
import 'package:messager/page/home_page.dart';

import '../model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  String? _lastName;
  String? _lastPassword;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    UserModel? userModel = await UserDao.get();
    _lastName = userModel?.name;
    _lastPassword = userModel?.password;

    print('===> init name:${userModel?.name}');
    print('===> init password:${userModel?.password}');

    _usernameController.text = _lastName ?? '';
    _passwordController.text = _lastPassword ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo_login.png',
                width: 140,
                height: 210,
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'アカウント',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFFE1E3E6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFFE1E3E6),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF015CD6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () async {
                    String name = _usernameController.text;
                    String password = _passwordController.text;

                    print('===> name:$name');
                    print('===> password:$password');

                    if (name.isEmpty || password.isEmpty) {
                      showToast('メールアドレスまたはパスワードを空にすることはできません');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    HttpServerApi httpServer = HttpServerApi();
                    UserModel? data = await httpServer.login(name, password);
                    setState(() {
                      isLoading = false;
                    });
                    if (data != null) {
                      navigateToHome();
                    }
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String msg) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      );
    EasyLoading.showToast(msg);
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(context),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

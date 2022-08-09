import 'dart:async';

import 'package:auth_platform/auth_service.dart';
import 'package:auth_platform/page_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this._authService);

  final AuthService _authService;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _pwd = '';

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget._authService.isAuthenticatedStream.listen((isAuthenticated) {
      print('===== isAuthenticated: $isAuthenticated');
      isAuthenticated ? GoRouter.of(context).go(PagePath.myPage) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(padding: const EdgeInsets.all(12), width: 300, color: Colors.black26, child: _form())));
  }

  _form() {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: TextFormField(
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                autofocus: true,
                onChanged: (text) => _email = text),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextFormField(
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                obscureText: true,
                onChanged: (text) => _pwd = text),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 16))),
                  onPressed: () => _login(_email, _pwd),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _login(email, pwd) {
    widget._authService.login(email, pwd);
    // Environment.authBaseUrl
    // window.location.href = 'https://google.com'
  }
}

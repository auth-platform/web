import 'package:auth_platform/page_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequireLoginPage extends StatefulWidget {
  @override
  _RequireLoginPageState createState() => _RequireLoginPageState();
}

class _RequireLoginPageState extends State<RequireLoginPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => GoRouter.of(context).go(PagePath.login));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Redirect to login page')));
  }
}

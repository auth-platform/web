import 'package:auth_platform/page_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage(this._title);

  final String _title;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => GoRouter.of(context).go(PagePath.home));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('${widget._title}\nRedirect to home page')));
  }
}

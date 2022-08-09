import 'package:auth_platform/auth_service.dart';
import 'package:auth_platform/components/side_menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class _FeatureItem {
  _FeatureItem(this.name, this.icon, this.action);
  final String name;
  final IconData icon;
  final void Function(BuildContext) action;
}

class MyPage extends StatelessWidget {
  MyPage(this._authService);

  final AuthService _authService;

  late final _items = [
    _FeatureItem('Profile', Icons.manage_accounts, (context) => print('Profile')),
    _FeatureItem('Password', Icons.change_circle, (context) => _displayChangePasswordDialog(context)),
    _FeatureItem('User management', Icons.people, (context) => print('User management')),
    _FeatureItem('Service management', Icons.miscellaneous_services, (context) => print('Service management')),
  ];

  late final _validIndexes = [0, 1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return IncludedMenuPage(
      _authService,
      title: const Text('My Page'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(width: 800),
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _buildProfile(context),
            const SizedBox(height: 12),
            Expanded(child: _buildFeature(context)),
          ]),
        ),
      ),
    );
  }

  _buildProfile(BuildContext context) {
    return Container(
      color: Colors.black26,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(width: 60, height: 60, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'ID: ${_authService.data?.id ?? 'None'}',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
              Text(
                'Email: ${_authService.data?.email ?? 'None'}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _buildFeature(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Wrap(
            children: _validIndexes
                .map((i) => GestureDetector(
                    onTap: () => _items[i].action(context), child: _buildCard(context, _items[i].icon, _items[i].name)))
                .toList()),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String text) {
    return Card(
        child: Container(
            width: 100,
            height: 120,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(child: Icon(icon, size: 40, color: Theme.of(context).primaryColor)),
                Container(
                  color: Colors.black.withAlpha(0x5F),
                  height: 40,
                  child: Center(
                    child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )));
  }

  _displayChangePasswordDialog(BuildContext context) {
    String _pwd = '';
    String _newPwd = '';
    String _confirmPwd = '';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Change password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40, child: TextField(onChanged: (text) => _pwd = text)),
                  const SizedBox(height: 8),
                  SizedBox(height: 40, child: TextField(onChanged: (text) => _newPwd = text)),
                  const SizedBox(height: 8),
                  SizedBox(height: 40, child: TextField(onChanged: (text) => _confirmPwd = text))
                ],
              ),
              contentPadding: const EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 24),
              actions: [
                TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      if (_pwd.isNotEmpty && _newPwd.isNotEmpty && _confirmPwd == _newPwd) {
                        Navigator.of(context).pop();
                        _authService
                            .changePassword(_pwd, _newPwd)
                            .then((_) => showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      title: Text('Change password'),
                                      content: Text('Successfully!'),
                                    )))
                            .catchError((e) => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Change password'),
                                      content: _buildError(context, e),
                                    )));
                        // Navigator.of(context).pop();
                      }
                    })
              ],
            ));
  }

  _buildError(BuildContext context, e) {
    if (e is DioError) {
      final errCode = e.response?.data['data'];
      if (errCode != null) {
        switch (errCode) {
          case 'wrong_pwd':
            return const Text('Wrong password!');
          default:
            return Text('Error with code $errCode');
        }
      }
    }
    if (e is FormatException) {
      return Text('Error by reason: ${e.message}');
    }
    return const Text('Unknown error');
  }
}

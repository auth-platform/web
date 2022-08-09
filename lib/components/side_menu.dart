import 'package:auth_platform/auth_service.dart';
import 'package:auth_platform/page_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class _SideMenuItem {
  _SideMenuItem(this.name, this.icon, this.action);
  final String name;
  final IconData icon;
  final void Function(BuildContext) action;
}

class IncludedMenuPage extends StatelessWidget {
  IncludedMenuPage(
    this._authService, {
    required Widget title,
    required Widget body,
  })  : _body = body,
        _title = title;

  final AuthService _authService;
  final Widget _body;
  final Widget _title;

  late final _items = [
    _SideMenuItem('Home', Icons.home, (context) => GoRouter.of(context).go(PagePath.home)),
    _SideMenuItem('Login', Icons.login, (context) => GoRouter.of(context).go(PagePath.login)),
    _SideMenuItem('My Page', Icons.library_books, (context) => GoRouter.of(context).go(PagePath.myPage)),
    _SideMenuItem('Logout', Icons.logout,
        (context) => _authService.logout().then((value) => GoRouter.of(context).go(PagePath.login))),
  ];

  late final _validIndexes = _authService.isAuthenticated ? [0, 2, 3] : [0, 1];

  @override
  Widget _buildMenu(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _validIndexes
              .map((i) => ListTile(
                    onTap: () => _items[i].action(context),
                    leading: Icon(_items[i].icon, color: Colors.white),
                    title: Text(_items[i].name),
                    textColor: Colors.white,
                    dense: true,
                  ))
              .toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuKey = GlobalKey();
    return SideMenu(
        key: sideMenuKey,
        type: SideMenuType.slide,
        background: Colors.blueGrey.shade700,
        menu: _buildMenu(context),
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    final state = sideMenuKey.currentState;
                    if (state != null && state is SideMenuState) {
                      state.isOpened ? state.closeSideMenu() : state.openSideMenu();
                    }
                  },
                ),
                title: _title),
            body: _body));
  }
}

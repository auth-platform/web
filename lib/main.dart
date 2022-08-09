import 'package:auth_platform/auth_service.dart';
import 'package:auth_platform/components/side_menu.dart';
import 'package:auth_platform/constants.dart';
import 'package:auth_platform/page_path.dart';
import 'package:auth_platform/pages/error_page.dart';
import 'package:auth_platform/pages/login_page.dart';
import 'package:auth_platform/pages/my_page.dart';
import 'package:auth_platform/pages/require_login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await AuthService.shared.initialize();
  runApp(App());
}

class NoTransitionRoute extends GoRoute {
  NoTransitionRoute(
      {required super.path, required Widget child, String? Function(BuildContext, GoRouterState)? validate})
      : super(pageBuilder: (context, state) {
          String? validateError;
          if (validate != null) {
            validateError = validate(context, state);
          }
          return validateError == null ? NoTransitionPage(child: child) : throw FormatException(validateError);
        });
}

class RequiredAuthRoute extends NoTransitionRoute {
  RequiredAuthRoute({required super.path, required super.child, required AuthService service})
      : super(validate: (_, __) => !service.isAuthenticated ? AppException.requiredAuth : null);
}

class App extends StatelessWidget {
  App({super.key});

  final GoRouter _router = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      NoTransitionRoute(path: PagePath.home, child: const HomePage(title: 'Auth Platform')),
      NoTransitionRoute(path: PagePath.login, child: LoginPage(AuthService.shared)),
      RequiredAuthRoute(path: PagePath.myPage, child: MyPage(AuthService.shared), service: AuthService.shared),
    ],
    errorPageBuilder: (context, state) {
      final exception = state.error;
      if (exception != null && exception is FormatException && exception.message == AppException.requiredAuth) {
        return NoTransitionPage(child: RequireLoginPage());
      }
      return NoTransitionPage(child: ErrorPage(state.error.toString()));
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightGreen, scaffoldBackgroundColor: Colors.blueGrey),
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IncludedMenuPage(AuthService.shared, title: Text(widget.title), body: const Center(child: Text('Home')));
  }
}

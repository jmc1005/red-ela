import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/config/theme_config.dart';
import 'app/presentation/routes/app_routes.dart';
import 'app/presentation/routes/routes.dart';
import 'l10n/locale_support.dart';
import 'provider/locale_provider.dart';

class Redela extends StatefulWidget {
  const Redela({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<Redela> createState() => _RedelaState();
}

class _RedelaState extends State<Redela> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    Redela.navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeConfig();

    return ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),
      builder: (context, child) {
        return Consumer<LocaleProvider>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () {
                // verificar el contexto hijo
                final focus = FocusScope.of(context);
                // minimizar el teclado al pulsar fuera en el hijo
                final focusedChild = focus.focusedChild;
                if (focusedChild != null && !focusedChild.hasPrimaryFocus) {
                  focusedChild.unfocus();
                }
              },
              child: MaterialApp(
                navigatorKey: Redela.navigatorKey,
                builder: (context, child) => ResponsiveBreakpoints.builder(
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                    const Breakpoint(
                        start: 1921, end: double.infinity, name: '4K'),
                  ],
                  child: child!,
                ),
                initialRoute: Routes.signIn,
                onGenerateRoute: generateRoute,
                // routes: appRoutes,
                theme: theme.light,
                locale: provider.locale,
                supportedLocales: L10n.support,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'app/config/theme_config.dart';
import 'app/presentation/routes/app_routes.dart';
import 'app/presentation/routes/routes.dart';
import 'l10n/locale_support.dart';
import 'provider/locale_provider.dart';

class Redela extends StatefulWidget {
  const Redela({super.key});

  @override
  State<Redela> createState() => _RedelaState();
}

class _RedelaState extends State<Redela> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.fragment);
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
                navigatorKey: _navigatorKey,
                initialRoute: Routes.signIn,
                // onGenerateRoute: generateRoute,
                routes: appRoutes,
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

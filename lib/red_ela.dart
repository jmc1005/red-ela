import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'app/config/theme_config.dart';

import 'app/presentation/routes/app_routes.dart';
import 'app/presentation/routes/routes.dart';
import 'l10n/locale_support.dart';
import 'provider/locale_provider.dart';

class Redela extends StatelessWidget {
  const Redela({super.key});

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
                initialRoute: Routes.signIn,
                routes: appRoutes,
                theme: theme.light,
                locale: provider.locale,
                supportedLocales: L10n.support,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
              ),
            );
          },
        );
      },
    );
  }
}

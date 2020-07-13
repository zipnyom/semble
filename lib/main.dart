import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:schuul/src/data/provider/mode_provider.dart';
import 'package:schuul/src/widgets/auth_stream.dart';

// void main() => initializeDateFormatting().then((_) => runApp(MyApp()));
void main() => runApp(MyApp());
// void main() =>  runApp(ZefyrApp());
// void main() =>  runApp(ShowCaseApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Mode()),
        // StreamProvider<FirebaseUser>.value(
        //     value: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('ko', 'KO'),
          ],
          theme: ThemeData(
              bottomSheetTheme:
                  BottomSheetThemeData(backgroundColor: Colors.transparent)),
          home: AuthStream()),
    );
  }
}

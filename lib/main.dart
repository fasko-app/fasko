import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/user_data.dart';
import 'package:fasko_mobile/models/user_settings.dart';
import 'package:fasko_mobile/pages/wrapper.dart';
import 'package:fasko_mobile/services/auth.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for hide bars
import 'package:window_manager/window_manager.dart';
import 'dart:async';

// for firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // add your file
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FaskoApp());

  // hide bars
  if (!kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }
}

class FaskoApp extends StatelessWidget {
  const FaskoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
        ProxyProvider<FaskoUser?, DatabaseService?>(
          update: ((context, value, previous) {
            if (value != null) {
              return DatabaseService(uid: value.uid);
            }
            return null;
          }),
        ),
        //(context) => DatabaseService(uid: context.watch<FaskoUser?>()!.uid)),
        // StreamProvider(
        //   create: (context) => context.read<DatabaseService>().userData,
        //   initialData: UserData(
        //     lists: [],
        //     settings: UserSettings(
        //       work: 30,
        //       rest: 5,
        //     ),
        //   ),
        // )
      ],
      builder: (context, child) {
        final db = context.watch<DatabaseService?>();
        if (db != null) {
          return StreamProvider<UserData>.value(
            initialData: UserData(
              lists: [],
              settings: UserSettings(
                work: 30,
                rest: 5,
              ),
            ),
            value: db.userData,
            child: MaterialApp(
              title: 'Fasko',
              theme: ThemeData(
                primarySwatch: Colors.grey,
                fontFamily: 'Inter',
                errorColor: const Color.fromARGB(255, 193, 54, 86),
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => const Wrapper(),
                //'/timer': (context) => const TimerPage(),
              },
            ),
          );
        }
        return MaterialApp(
          title: 'Fasko',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            fontFamily: 'Inter',
            errorColor: const Color.fromARGB(255, 193, 54, 86),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const Wrapper(),
            //'/timer': (context) => const TimerPage(),
          },
        );
      },
      child: MaterialApp(
        title: 'Fasko',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: 'Inter',
          errorColor: const Color.fromARGB(255, 193, 54, 86),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          //'/timer': (context) => const TimerPage(),
        },
      ),
    );
  }
}

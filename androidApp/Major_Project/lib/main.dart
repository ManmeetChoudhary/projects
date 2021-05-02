import 'package:animated_splash/animated_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/local_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:major_project/models/live_chat_message_model.dart';
import 'package:major_project/services/firestore_services.dart';
import 'package:major_project/services/location_service.dart';
import 'package:major_project/services/marker_bitmapper.dart';
import 'package:major_project/services/localdb/covid_db.dart';
import 'package:major_project/services/firestore_services.dart';
import 'package:major_project/services/marker_bitmapper.dart';
import 'package:major_project/services/localdb/covid_db.dart';
import 'package:major_project/services/localdb/sqlite_services.dart';
import 'package:major_project/views/components/navigation_controller.dart';
import 'package:major_project/views/pages/chat_page/chat_page.dart';
import 'package:major_project/views/pages/login_page.dart';
import 'package:major_project/views/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'models/chat_session_model.dart';
import 'models/markerpopup_model.dart';
import 'models/post_model.dart';
import 'models/profile_model.dart';
import 'models/settings_model.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/flutter_i18n'),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  await Firebase.initializeApp();
  CovidDB.instance.init();
  await LocationService.instance.init();
  await Flame.util.fullScreen();
  await Flame.images.load('rowrow_2.png');
  //wrap in localdb init

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User>.value(value: FirebaseAuth.instance.userChanges()),
        StreamProvider<LocationData>.value(
            value: LocationService.instance.locationStream),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //async load things like bitmap images
    MarkerBitmapper.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    String uid;
    if (user != null) {
      uid = user.uid;
    }
    LocationData location = context.watch<LocationData>();
    final db = FirebaseService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Settings()),
        //map marker provider, this really could be somewhere else
        ChangeNotifierProvider(create: (context) => MarkerPopupModel()),
        //todo:decide where to put these later
        //have to rewrite these to be mutable
        StreamProvider<List<Post>>.value(
            value: db.streamPostsInRadius(
                radius: 2550, currentLocation: location)),
        StreamProvider<List<LiveChatMessage>>(
            create: (_) => db.streamLiveChatMessages(
                radius: 1, currentLocation: location)),
        StreamProvider<List<Profile>>.value(
            value: db.streamProfilesInRadius(
                radius: 2550, currentLocation: location)),
        StreamProvider<List<ChatSession>>(
          create: (_) => db.streamChatSessions(uid),
        )
      ],
      child: Consumer<Settings>(builder: (context, settings, child) {
        return MaterialApp(
            localizationsDelegates: [
              FlutterI18nDelegate(
                translationLoader: FileTranslationLoader(
                    useCountryCode: false,
                    fallbackFile: 'en',
                    basePath: 'assets/flutter_i18n'),
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'CA'), // english ca
              const Locale('fr', 'CA'), // french ca
              const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans',
                  countryCode: 'CN'), // chinese
              //todo: replace all ui strings with AppLocalizations.of(context).stringName
            ],
            title: 'Flutter Demo',
            theme: settings.getTheme(),
            home: SplashScreen.navigate(
              name: 'assets/images/intro.flr',
              loopAnimation: 'assets/images/intro.flr',
              next: (_) => NavigationController(),
              until: () => Future.delayed(Duration(seconds: 10)),
              startAnimation: '1',
            ),
            routes: <String, WidgetBuilder>{
              //named routes
              '/home': (BuildContext context) => NavigationController(),
              '/login': (BuildContext context) => LoginPage(),
              '/chatPage': (BuildContext context) => ChatPage(),
              '/map': (BuildContext context) => MapPage(),
            });
      }),
    );
  }

  Function duringSplash = () {
    return;
  };
}

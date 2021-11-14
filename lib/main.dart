import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/view/layout_view/layout_view.dart';
import 'constants/cache_constants.dart';
import 'helper/cache_helper.dart';
import 'providers.dart';
import 'routes.dart';
import 'view/login_view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.initializePreferences();
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: mainColor,
          accentColor: Colors.pink,
          fontFamily: 'Jannah',
          scaffoldBackgroundColor: lightMainColor,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: blackColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: TextStyle(
              color: blackColor,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              color: blackColor,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          buttonTheme: ButtonThemeData(
            splashColor: mainColor.withOpacity(0.1),
            highlightColor: mainColor.withOpacity(0.2),
          ),
          appBarTheme: const AppBarTheme(
            backwardsCompatibility: false,
            backgroundColor: lightMainColor,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(
              color: darkMainColor,
            ),
            titleTextStyle: TextStyle(
              color: darkMainColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
            iconTheme: IconThemeData(color: darkMainColor),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            elevation: 20.0,
            selectedLabelStyle: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(height: 1.5),
            unselectedItemColor: greyColor,
          ),
        ),
        initialRoute: CacheHelper.getToken(tokenKey) == null
            ? LoginView.id
            : LayoutView.id,
        routes: Routes.routes,
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/provider/bottom_nav_bar_provider.dart';
import 'package:social_app/view/layout_view/layout_view.dart';
import 'package:social_app/view/new_post_view/new_post_view.dart';
import 'package:social_app/view/signup_view/signup_view.dart';
import 'constants/cache_constants.dart';
import 'controller/chat_controller.dart';
import 'controller/comment_controller.dart';
import 'controller/login_controller.dart';
import 'controller/messages_controller.dart';
import 'controller/new_message_controller.dart';
import 'controller/new_post_controller.dart';
import 'controller/posts_controller.dart';
import 'controller/edit_profile_controller.dart';
import 'controller/signup_controller.dart';
import 'controller/user_profile_controller.dart';
import 'helper/cache_helper.dart';
import 'view/chat_details_view/chat_details_view.dart';
import 'view/comments_view/comments_view.dart';
import 'view/edit_profile_view/edit_profile_view.dart';
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
      providers: [
        ChangeNotifierProvider<BottomNavBarProvider>(
          create: (_) => BottomNavBarProvider(),
        ),
        ChangeNotifierProvider<SignupController>(
          create: (_) => SignupController(),
        ),
        ChangeNotifierProvider<LoginController>(
          create: (_) => LoginController(),
        ),
        ChangeNotifierProvider<EditProfileController>(
          create: (_) => EditProfileController(),
        ),
        ChangeNotifierProvider<PostsController>(
          create: (_) => PostsController(),
        ),
        ChangeNotifierProvider<NewPostController>(
          create: (_) => NewPostController(),
        ),
        ChangeNotifierProvider<UserProfileController>(
          create: (_) => UserProfileController(),
        ),
        ChangeNotifierProvider<CommentController>(
          create: (_) => CommentController(),
        ),
        ChangeNotifierProvider<ChatsController>(
          create: (_) => ChatsController(),
        ),
        ChangeNotifierProvider<MessagesController>(
          create: (_) => MessagesController(),
        ),
        ChangeNotifierProvider<NewMessageController>(
          create: (_) => NewMessageController(),
        ),
        // ChangeNotifierProvider<NewMessageController>(
        //   create: (_) => NewMessageController(),
        // ),
        // ChangeNotifierProvider<NewMessageController>(
        //   create: (_) => NewMessageController(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: mainColor,
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
              fontSize: 20.0,
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
        // initialRoute: LoginView.id,
        routes: {
          LoginView.id: (_) => LoginView(),
          SignUpView.id: (_) => SignUpView(),
          LayoutView.id: (_) => LayoutView(),
          NewPostView.id: (_) => NewPostView(),
          EditProfileView.id: (_) => EditProfileView(),
          CommentsView.id: (_) => CommentsView(),
          ChatDetailsView.id: (_)=> ChatDetailsView(),
        },
        // home: Test(),
      ),
    );
  }
}

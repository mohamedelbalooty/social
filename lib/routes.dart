import 'package:flutter/material.dart';
import 'view/edit_profile_view/edit_profile_view.dart';
import 'view/layout_view/layout_view.dart';
import 'view/login_view/login_view.dart';
import 'view/new_post_view/new_post_view.dart';
import 'view/signup_view/signup_view.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    LoginView.id: (_) => LoginView(),
    SignUpView.id: (_) => SignUpView(),
    LayoutView.id: (_) => LayoutView(),
    NewPostView.id: (_) => NewPostView(),
    EditProfileView.id: (_) => EditProfileView(),
  };
}

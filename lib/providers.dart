import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:social_app/provider/bottom_nav_bar_provider.dart';
import 'controller/chat_controller.dart';
import 'controller/comments_controller.dart';
import 'controller/comments_number_controller.dart';
import 'controller/edit_profile_controller.dart';
import 'controller/likes_controller.dart';
import 'controller/likes_number_controller.dart';
import 'controller/login_controller.dart';
import 'controller/messages_controller.dart';
import 'controller/new_comment_controller.dart';
import 'controller/new_like_controller.dart';
import 'controller/new_message_controller.dart';
import 'controller/new_post_controller.dart';
import 'controller/posts_controller.dart';
import 'controller/signup_controller.dart';
import 'controller/user_profile_controller.dart';

class Providers {
  static List<SingleChildWidget> providers = [
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
    ChangeNotifierProvider<NewCommentController>(
      create: (_) => NewCommentController(),
    ),
    ChangeNotifierProvider<CommentsController>(
      create: (_) => CommentsController(),
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
    ChangeNotifierProvider<LikesNumberController>(
      create: (_) => LikesNumberController(),
    ),
    ChangeNotifierProvider<CommentsNumberController>(
      create: (_) => CommentsNumberController(),
    ),
    ChangeNotifierProvider<NewLikeProvider>(
      create: (_) => NewLikeProvider(),
    ),
    ChangeNotifierProvider<LikesController>(
      create: (_) => LikesController(),
    ),
  ];
}

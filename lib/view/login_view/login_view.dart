import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/cache_constants.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/login_controller.dart';
import 'package:social_app/helper/cache_helper.dart';
import 'package:social_app/states/auth_controllers_states.dart';
import 'package:social_app/view/layout_view/layout_view.dart';
import 'package:social_app/view/signup_view/signup_view.dart';
import '../app_components.dart';

class LoginView extends StatelessWidget {
  static const String id = 'LoginView';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BuildAppGradientBackground(
      widgetBody: Scaffold(
        backgroundColor: transparentColor,
        body: SafeArea(
          child: Consumer<LoginController>(
            builder: (context, provider, child) {
              return ModalProgressHUD(
                inAsyncCall: provider.loginStates == LoginControllerStates.LoadingState,
                progressIndicator: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // const SizedBox(
                            //   height: 50.0,
                            // ),
                            Hero(
                              tag: 'appLogo',
                              child: BuildAppLogo(),
                            ),
                            BuildAuthenticationViewTitle(),
                            BuildAuthenticationViewSupTitle(),
                            const SizedBox(
                              height: 50.0,
                            ),
                            BuildAuthTextFormField(
                              key: UniqueKey(),
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter your email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            constDistance(),
                            BuildAuthTextFormField(
                              key: UniqueKey(),
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              keyboardType: TextInputType.visiblePassword,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter your password';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            constDistance(),
                            BuildSubmitAuthButton(
                              buttonTitle: 'login',
                              onClick: () async {
                                if (_globalKey.currentState.validate()) {
                                  await provider.userLogin(_emailController.text,
                                      _passwordController.text);
                                  if (provider.loginStates ==
                                      LoginControllerStates.ErrorState) {
                                    showToast(context, provider.errorMessage);
                                  } else if (provider.loginStates ==
                                      LoginControllerStates.SuccessState) {
                                    CacheHelper.setToken(
                                        tokenKey: tokenKey,
                                        tokenValue: provider.uId);
                                    replacementNamedNavigateTo(
                                        context, LayoutView.id);
                                  }
                                }
                              },
                            ),
                            BuildAuthQuestion(
                              key: ValueKey('login'),
                              questionTitle: 'Don\'t have an account?',
                              authTitle: 'Sign Up Now',
                              onClick: () {
                                namedNavigateTo(context, SignUpView.id);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

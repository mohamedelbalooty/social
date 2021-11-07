import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/cache_constants.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/signup_controller.dart';
import 'package:social_app/helper/cache_helper.dart';
import 'package:social_app/states/auth_controllers_states.dart';
import 'package:social_app/view/layout_view/layout_view.dart';
import 'package:social_app/view/login_view/login_view.dart';
import '../app_components.dart';

class SignUpView extends StatelessWidget {
  static const String id = 'SignUpView';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BuildAppGradientBackground(
      widgetBody: Scaffold(
        backgroundColor: transparentColor,
        body: SafeArea(
          child: Consumer<SignupController>(
            builder: (context, provider, child) {
              return ModalProgressHUD(
                inAsyncCall: provider.signupStates == SignupControllerStates.LoadingState,
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
                            //   height: 30,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     InkWell(
                            //       onTap: () {
                            //         Navigator.pop(context);
                            //       },
                            //       child: Text(
                            //         'Back',
                            //         style: TextStyle(
                            //           decoration: TextDecoration.underline,
                            //           color: whiteColor,
                            //           fontSize: 16.0,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Hero(
                              tag: 'appLogo',
                              child: BuildAppLogo(),
                            ),
                            BuildAuthenticationViewTitle(),
                            BuildAuthenticationViewSupTitle(),
                            constDistance(),
                            BuildAuthTextFormField(
                              key: UniqueKey(),
                              controller: _usernameController,
                              hint: 'Username',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter your username';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            constDistance(),
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
                            BuildAuthTextFormField(
                              key: UniqueKey(),
                              controller: _phoneController,
                              hint: 'Phone',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Enter your phone number';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            constDistance(),
                            BuildSubmitAuthButton(
                              buttonTitle: 'Signup',
                              onClick: () async {
                                if (_globalKey.currentState.validate()) {
                                  await provider.userSignup(
                                      _usernameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                      _phoneController.text);
                                  if (provider.signupStates ==
                                      SignupControllerStates.ErrorState) {
                                    showToast(context, provider.errorMessage);
                                  } else if (provider.signupStates ==
                                      SignupControllerStates.SuccessState) {
                                    CacheHelper.setToken(
                                        tokenKey: tokenKey, tokenValue: provider.uId);
                                    replacementNamedNavigateTo(
                                        context, LayoutView.id);
                                  }
                                }
                              },
                            ),
                            BuildAuthQuestion(
                              key: ValueKey('signup'),
                              questionTitle: 'Do you have an account?',
                              authTitle: 'Login Now',
                              onClick: () {
                                namedNavigateTo(context, LoginView.id);
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

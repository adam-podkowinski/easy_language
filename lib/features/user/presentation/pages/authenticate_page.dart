import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/show_error.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatePage extends StatelessWidget {
  final bool signUp;
  final bool shouldAnimate;

  Widget _buildAnimation({required Widget child, String? tag}) {
    return shouldAnimate
        ? Hero(
            tag: tag ?? '',
            child: child,
          )
        : child;
  }

  const AuthenticatePage({
    Key? key,
    this.signUp = false,
    this.shouldAnimate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordConfirmationController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();

    SharedPreferences.getInstance().then(
      (value) => value.setBool(isStartupId, false),
    );

    final failure = context.watch<UserProvider>().userFailure;

    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      if (failure != null && failure is UserUnauthenticatedFailure) {
        showError(context, failure.toString());
        context.read<UserProvider>().clearError();
      }
    });

    return Scaffold(
      backgroundColor: primaryVariant,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100.h,
      ),
      body: Theme(
        data: buildDark(context),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      signUp ? 'Sign up' : 'Login',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Mulish',
                          ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.person,
                      size: 50.h,
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (String? s) {
                          if (s == null) {
                            return 'Please, provide an e-mail address.';
                          }
                          if (!EmailValidator.validate(s) || s.length > 140) {
                            return 'Please, provide a valid e-mail address.';
                          }
                        },
                        decoration: buildInputDecoration('E-mail'),
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator: (pass) {
                          if (pass == null) {
                            return 'Please, provide a password.';
                          } else if (pass.length < 6 || pass.length > 140) {
                            return 'Password length should be 6 - 140 characters.';
                          }
                        },
                        decoration: buildInputDecoration('Password'),
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      if (signUp)
                        TextFormField(
                          controller: passwordConfirmationController,
                          obscureText: true,
                          validator: (confirmation) {
                            if (confirmation != passwordController.value.text) {
                              return "Passwords don't match.";
                            }
                          },
                          decoration: buildInputDecoration(
                            'Password confirmation',
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: _buildAnimation(
                          tag: 'login',
                          child: SizedBox(
                            height: 40.h,
                            child: ElevatedButton(
                              child: Text(
                                signUp ? 'Sign up' : 'Login',
                              ),
                              onPressed: () {
                                if (!(formKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }
                                signUp
                                    // Sign up
                                    ? context.read<UserProvider>().register(
                                        {
                                          'email': emailController.value.text,
                                          'password':
                                              passwordController.value.text,
                                          'password_confirmation':
                                              passwordConfirmationController
                                                  .value.text,
                                        },
                                      )
                                    // Log in
                                    : context.read<UserProvider>().login(
                                        {
                                          'email': emailController.value.text,
                                          'password':
                                              passwordController.value.text,
                                        },
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 8,
                        child: _buildAnimation(
                          tag: 'signup',
                          child: SizedBox(
                            height: 40.h,
                            child: OutlinedButton(
                              child: Text(
                                signUp ? 'Log in instead' : 'Sign up instead',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => AuthenticatePage(
                                      signUp: !signUp,
                                      shouldAnimate: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.r),
        borderSide: const BorderSide(
          color: Colors.white54,
        ),
      ),
    );
  }
}

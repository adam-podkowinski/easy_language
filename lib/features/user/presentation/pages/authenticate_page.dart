import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/show_error.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
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

    SharedPreferences.getInstance().then(
      (value) => value.setBool(isStartupId, false),
    );

    if (context.watch<UserProvider>().userFailure!= null) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        showError(context, context.read<UserProvider>().userFailure.toString());
        context.read<UserProvider>().clearError();
      });
    }

    return Scaffold(
      backgroundColor: primaryVariant,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100.h,
      ),
      body: Center(
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
              Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.sw),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.sw),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.sw),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.sw),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  if (signUp)
                    TextFormField(
                      controller: passwordConfirmationController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password confirmation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.sw),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.sw),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                ],
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
                            onPressed: () => signUp
                                ? context.read<UserProvider>().register(
                                    {
                                      'email': emailController.value.text,
                                      'password': passwordController.value.text,
                                      'password_confirmation':
                                          passwordConfirmationController
                                              .value.text,
                                    },
                                  )
                                : context.read<UserProvider>().login(
                                    {
                                      'email': emailController.value.text,
                                      'password': passwordController.value.text,
                                    },
                                  ),
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
    );
  }
}

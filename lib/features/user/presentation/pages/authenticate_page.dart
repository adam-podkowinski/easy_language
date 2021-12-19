import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/presentation/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatePage extends StatelessWidget {
  final bool signUp;

  const AuthenticatePage({Key? key, this.signUp = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then(
      (value) => value.setBool(isStartupId, false),
    );
    return Scaffold(
      backgroundColor: primaryVariant,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100.h,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.sp, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                signUp ? 'Sign Up' : 'Login',
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'Mulish',
                ),
              ),
              Column(
                children: [
                  TextFormField(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: Text(signUp ? 'Sign up' : 'Sign in'),
                    onPressed: () {},
                  ),
                  OutlinedButton(
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
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

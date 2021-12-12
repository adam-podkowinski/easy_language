import 'package:easy_language/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final login = context.watch<LoginProvider>();
    return ElevatedButton(
      onPressed: null,
      // onPressed: login.isSignedIn
      //     ? login.signOut
      //     : () => loginBranch(
      //           context,
      //           login,
      //         ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          // login.isSignedIn ? Colors.red : Colors.green,
          Colors.red,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.w),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            '$svgPrefix/google_play.svg',
            height: 40.h,
          ),
          SizedBox(
            width: 5.w,
          ),
          const Text(
            // login.isSignedIn ? 'Sign out' : 'Sign in',
            'Sign in',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

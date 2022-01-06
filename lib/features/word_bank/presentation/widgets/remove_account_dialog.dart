import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RemoveAccountDialog extends StatelessWidget {
  const RemoveAccountDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text('Remove account'),
      insetPadding: EdgeInsets.zero,
      shape: const ContinuousRectangleBorder(),
      actionsPadding: EdgeInsets.only(right: 10.w, bottom: 10.h),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 10.w,
        ),
        ElevatedButton(
          onPressed: () {
            if (!(formKey.currentState?.validate() ?? false)) return;
            context.read<UserProvider>().removeAccount(
                  context: context,
                  email: emailController.value.text,
                  password: passwordController.value.text,
                );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Text('Proceed'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            removeAccountContent,
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 20.h,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: buildInputDecoration(
                    context,
                    hint: 'E-mail',
                  ),
                  validator: (String? s) {
                    if (s == null) {
                      return 'Please, provide an e-mail address.';
                    }
                    if (!EmailValidator.validate(s) || s.length > 140) {
                      return 'Please, provide a valid e-mail address.';
                    }
                  },
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: buildInputDecoration(context, hint: 'Password'),
                  validator: (pass) {
                    if (pass == null) {
                      return 'Please, provide a password.';
                    } else if (pass.length < 6 || pass.length > 140) {
                      return 'Password length should be 6 - 140 characters.';
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(
    BuildContext context, {
    required String hint,
  }) {
    final radius = 15.r;
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
      ),
    );
  }
}

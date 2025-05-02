import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/authview_model_provider.dart';
import 'package:todo_app/view/dashboard.dart';
import 'package:todo_app/view/registeration_page.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/widgets/app_textfield.dart';
import 'package:todo_app/widgets/ui_extensions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final size = MediaQuery.sizeOf(context);
    // final authProvider = AuthProvider.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Login',
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      20.g,
                      AppTextField(
                        labelText: 'Your Email',
                        controller: authVM.emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      12.g,
                      AppTextField(
                        labelText: 'Password',
                        controller: authVM.passwordController,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      20.g,

                      authVM.user.loading
                          ? const CircularProgressIndicator()
                          : AppButton(
                            width: size.width,
                            onPressed: () async {
                              await authVM.login(
                                authVM.emailController.text.trim(),
                                authVM.passwordController.text.trim(),
                              );
                              if (authVM.user.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to login')),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardView(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Login',
                              style: textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                      if (authVM.user.hasError)
                        const Text(
                          'Login Failed',
                          style: TextStyle(color: Colors.red),
                        ),
                      Gap(20),

                      Text.rich(
                        TextSpan(
                          text: 'Dont have an account? ',
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Resigter',
                              style: textTheme.bodyLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => RegisterationPage(),
                                        ),
                                      );
                                    },
                            ),
                          ],
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
}

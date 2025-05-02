import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/authview_model_provider.dart';
import 'package:todo_app/view/dashboard.dart';
import 'package:todo_app/view/login_page.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/widgets/app_textfield.dart';

class RegisterationPage extends StatelessWidget {
  const RegisterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final size = MediaQuery.sizeOf(context);
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
                      Text(
                        'Register',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: authVM.nameController,
                        labelText: 'Your Name',
                        hintText: 'Name',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: authVM.emailController,
                        labelText: 'Your Email',
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: authVM.passwordController,
                        labelText: 'Password',
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        width: size.width,
                        onPressed: () {
                          if (authVM.nameController.text.isEmpty ||
                              authVM.emailController.text.isEmpty ||
                              authVM.passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Plaese fill all fields')),
                            );
                          } else {
                            authVM.register(
                              authVM.nameController.text.trim(),
                              authVM.emailController.text.trim(),
                              authVM.passwordController.text.trim(),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardView(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Register',
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
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
                                          builder: (context) => LoginPage(),
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

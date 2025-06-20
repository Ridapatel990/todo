import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/authview_model_provider.dart';
import 'package:todo_app/business_logic/dashboard_provider.dart';
import 'package:todo_app/view/login_page_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                'Your Email: ${authVM.emailController.text}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Logout'),
                trailing: Icon(Icons.logout, color: Colors.red),
                onTap: () {
                  dashboardProvider.setIndex(0);
                  authVM.logout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPageView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

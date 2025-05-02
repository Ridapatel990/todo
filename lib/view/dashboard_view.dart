import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/dashboard_provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/view/completed_page_view.dart';
import 'package:todo_app/view/create_todo.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view/settings_view.dart';
import 'package:todo_app/view/shared_page_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoModelView>(context, listen: false).fetchUserTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardViewModel>(context);
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    const destinations = [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      // NavigationDestination(icon: Icon(Icons.push_pin), label: 'Pinned'),
      NavigationDestination(icon: Icon(Icons.done_all), label: 'Completed'),
      NavigationDestination(icon: Icon(IconsaxPlusBold.share), label: 'Shared'),
      NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
    ];

    final List<Widget> pages = [
      HomeView(),
      // PinnedPage(),
      CompletedPageView(),
      SharedPageView(),
      SettingsView(),
    ];
    return Scaffold(
      body: pages[dashboardProvider.currentIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_todo',
        backgroundColor: theme.colorScheme.secondary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodo()),
          );
        },
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: dashboardProvider.currentIndex,
        onDestinationSelected: (int index) {
          dashboardProvider.setIndex(index); // Use Provider to update
        },
        destinations: destinations,
      ),
    );
  }
}

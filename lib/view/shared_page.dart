import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/widgets/new_todo_card.dart';

class SharedPage extends StatefulWidget {
  const SharedPage({super.key});

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoModelView>(context, listen: false).fetchSharedTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoVM = Provider.of<TodoModelView>(context);
    final currentUserEmail = todoVM.currentUserEmail;
    // Filter shared todos only
    final sharedTodos =
        todoVM.todos
            .where((todo) => todo.sharedWith.contains(currentUserEmail))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Todos')),
      body:
          sharedTodos.isEmpty
              ? Center(
                child: Text(
                  'No shared todos yet!',
                  style: theme.textTheme.titleLarge,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sharedTodos.length,
                itemBuilder: (context, index) {
                  final todo = sharedTodos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                todo.title,
                                style: theme.textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Todo'),
                                        content: const Text(
                                          'Are you sure you want to delete this todo?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              todoVM.deleteSharedTodo(todo.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          // Text(todo.title, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text("Owner email: ${todo.userEmail}"),
                          Text("Shared with: ${todo.sharedWith.join(', ')}"),
                          const SizedBox(height: 8),
                          NewTodoCard(todoModel: todo),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

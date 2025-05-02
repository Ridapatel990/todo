import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoDetailView extends StatelessWidget {
  final TodoModel todoModel;

  const TodoDetailView({super.key, required this.todoModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoVM = Provider.of<TodoModelView>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(todoModel.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final emailController = TextEditingController();
              final List<String> emailsToShare = [];

              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Share Todo with others'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter email',
                                  hintText: 'example@domain.com',
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  if (email.isNotEmpty &&
                                      !emailsToShare.contains(email)) {
                                    setState(() {
                                      emailsToShare.add(email);
                                    });
                                    emailController.clear();
                                  }
                                },
                                child: const Text('Add Email'),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children:
                                    emailsToShare
                                        .map(
                                          (email) => Chip(
                                            label: Text(email),
                                            onDeleted: () {
                                              setState(() {
                                                emailsToShare.remove(email);
                                              });
                                            },
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final emailSubject = Uri.encodeComponent(
                                'Todo: ${todoModel.title}',
                              );
                              final emailBody = Uri.encodeComponent('''
Title: ${todoModel.title}
Description: ${todoModel.description}
Due: ${DateFormat.yMMMMd().format(todoModel.dueDate)} at ${DateFormat.jm().format(todoModel.dueDate)}
Subtasks:
${todoModel.subTasks.map((e) => '- ${e.title} ${e.isCompleted ? "(Completed)" : ""}').join('\n')}
''');

                              final recipients = emailsToShare.join(',');
                              final mailUrl = Uri.parse(
                                'mailto:$recipients?subject=$emailSubject&body=$emailBody',
                              );

                              if (await canLaunchUrl(mailUrl)) {
                                await launchUrl(mailUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not launch email app'),
                                  ),
                                );
                              }

                              Navigator.pop(context);

                              await todoVM.shareTodo(
                                todoModel.id,
                                emailsToShare,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Todo shared successfully!'),
                                ),
                              );
                            },
                            child: const Text('Share'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(todoModel.description),

            const SizedBox(height: 16),
            Text('Due Date:', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(DateFormat.yMMMMd().format(todoModel.dueDate)),

            const SizedBox(height: 16),
            Text('Time:', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(DateFormat.jm().format(todoModel.dueDate)),

            const SizedBox(height: 24),
            Consumer<TodoModelView>(
              builder: (context, todoVM, _) {
                final updatedTodo = todoVM.todos.firstWhere(
                  (t) => t.id == todoModel.id,
                );

                if (updatedTodo.subTasks.isEmpty) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subtasks:', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...updatedTodo.subTasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subTask = entry.value;
                      return GestureDetector(
                        onTap: () {
                          todoVM.toggleSubTaskCompletion(updatedTodo.id, index);
                        },
                        child: Row(
                          children: [
                            Icon(
                              subTask.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color:
                                  subTask.isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              subTask.title,
                              style: TextStyle(
                                decoration:
                                    subTask.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

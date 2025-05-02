import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/view/todo_detail_view.dart';

class NewTodoCard extends StatelessWidget {
  const NewTodoCard({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    final todoVM = Provider.of<TodoModelView>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Dismissible(
        key: ValueKey(todoModel.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.red.withOpacity(0.5),
                Colors.red,
              ],
              stops: const [0, 0.2, 1],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss:
            (direction) => showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Delete Todo'),
                    content: const Text(
                      'Are you sure you want to delete this todo?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          todoVM.deleteTodo(todoModel.id);
                          Navigator.of(context).pop(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Todo ${todoModel.title} deleted'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                    ],
                  ),
            ),
        onDismissed: (direction) {
          todoVM.deleteTodo(todoModel.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todo ${todoModel.title} deleted'),
              backgroundColor: Colors.red,
            ),
          );
        },
        child: Material(
          elevation: 1,
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailView(todoModel: todoModel),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todoModel.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    todoModel.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16),
                      const SizedBox(width: 4),
                      Text(DateFormat.yMMMMd().format(todoModel.dueDate)),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(DateFormat.jm().format(todoModel.dueDate)),
                    ],
                  ),
                  if (todoModel.subTasks.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.task_alt_outlined),
                        const SizedBox(width: 4),
                        Text(
                          '${todoModel.subTasks.where((e) => e.isCompleted).length}/${todoModel.subTasks.length} tasks done',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

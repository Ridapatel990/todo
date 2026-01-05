import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/widgets/ui_extensions.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todoModel});

  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoVM = Provider.of<TodoModelView>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final horizontalPadding = width * 0.03;
        final verticalPadding = horizontalPadding / 2;
        return Padding(
          padding: (height * .01).pb,
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
              padding: 16.pr,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) {
              return showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Todo'),
                      content: const Text(
                        'Are you sure you want to delete this todo?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call the delete function here
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            'Delete',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
              );
            },
            onDismissed: (direction) {
              todoVM.deleteTodo(todoModel.id);
              // AllSnackbars.showSnackBar(
              //   context: context,
              //   title: 'Todo Deleted',
              //   message: 'Todo ${todoModel.title} deleted',
              //   contentType: ContentType.failure,
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Todo ${todoModel.title} deleted',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: InkWell(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                margin: 0.pa,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      width: double.infinity,
                      padding: 0.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding,
                      ),
                      child: Row(
                        children: [
                          8.w,
                          Text(
                            todoModel.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: width * .04,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {},
                            child: const SizedBox.square(
                              dimension: 30,
                              child: Icon(Icons.more_horiz),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: verticalPadding.pa,
                      child: Row(
                        children: [
                          AutoSizeText(
                            todoModel.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: width * .035,
                            ),
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                            maxLines: height < 130 ? 1 : 2,
                          ),
                          4.g,
                          Wrap(
                            spacing: 12,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_month,

                                    size: width * .035,
                                  ),
                                  4.w,
                                  Text(
                                    DateFormat.yMMMMd().format(
                                      todoModel.dueDate,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: width * .045,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.alarm, size: width * .035),
                                  4.w,
                                  Text(
                                    DateFormat.jm().format(todoModel.dueDate),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: width * .045,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (todoModel.subTasks.isNotEmpty) ...[
                      const Icon(Icons.task_alt_outlined),
                      4.w,
                      Text(
                        '${todoModel.subTasks.where((element) => element.isCompleted).length}/${todoModel.subTasks.length}',
                        style: theme.textTheme.bodyLarge?.copyWith(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

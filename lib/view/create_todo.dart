import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/business_logic/todo_model_provider.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/widgets/app_textfield.dart';

class CreateTodo extends StatelessWidget {
  const CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final createTodoVM = Provider.of<TodoModelView>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: AppButton(
          width: size.width,
          heroTag: 'create_todo',
          onPressed: () async {
            if (createTodoVM.titleController.text.isEmpty ||
                createTodoVM.descriptionController.text.isEmpty ||
                createTodoVM.dateController.text.isEmpty ||
                createTodoVM.timeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }
            await createTodoVM.createTodo(context);
          },
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: const Text('Create Todo'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: createTodoVM.titleController,
                    labelText: 'Title',
                    hintText: 'Title',
                    keyboardType: TextInputType.text,
                  ),
                  Gap(8),
                  AppTextField(
                    controller: createTodoVM.descriptionController,
                    labelText: 'Description',
                    hintText: 'Description',
                    keyboardType: TextInputType.multiline,
                  ),
                  Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: createTodoVM.dateController,
                          hintText: DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.now()),
                          labelText: 'Date',
                          readOnly: true,

                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            ).then((date) {
                              if (date != null) {
                                createTodoVM.setDate(date);
                              }
                            });
                          },
                        ),
                      ),
                      Gap(8),
                      Expanded(
                        child: AppTextField(
                          controller: createTodoVM.timeController,
                          hintText: DateFormat('hh:mm a').format(
                            DateTime.now().add(const Duration(minutes: 2)),
                          ),
                          labelText: 'Time',

                          readOnly: true,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: createTodoVM.selectedTime,
                              builder: (context, child) {
                                return Theme(
                                  data: theme.copyWith(),
                                  child: MediaQuery(
                                    data: MediaQuery.of(
                                      context,
                                    ).copyWith(alwaysUse24HourFormat: false),
                                    child: child!,
                                  ),
                                );
                              },
                            ).then((time) {
                              if (time != null) {
                                createTodoVM.setTime(time, context);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                  Text('Sub Tasks', style: theme.textTheme.titleLarge),
                  Gap(8),
                  ...createTodoVM.subTaskControllers.mapIndexed(
                    (i, e) => Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: e,
                            hintText: 'Sub Task',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            createTodoVM.removeSubTask(i);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  AppButton(
                    color: Colors.transparent,
                    borderColor: theme.primaryColor,
                    width: size.width,
                    onPressed: () {
                      if (createTodoVM.subTaskControllers.isEmpty) {
                        createTodoVM.addSubTask();
                        return;
                      }
                      if (createTodoVM
                          .subTaskControllers
                          .last
                          .text
                          .isNotEmpty) {
                        createTodoVM.addSubTask();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter sub task'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Add Sub Task',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

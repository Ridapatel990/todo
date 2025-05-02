import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoModelView with ChangeNotifier {
  final List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  void addTodo(TodoModel todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  TodoModel? _selectedTodo;

  TodoModel? get selectedTodo => _selectedTodo;
  set selectedTodo(TodoModel? todo) {
    _selectedTodo = todo;
    notifyListeners();
  }

  String get currentUserEmail {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now().replacing(
    minute: TimeOfDay.now().minute < 58 ? TimeOfDay.now().minute + 2 : 0,
    hour:
        TimeOfDay.now().minute < 58
            ? TimeOfDay.now().hour
            : TimeOfDay.now().hour + 1,
  );

  List<TextEditingController> subTaskControllers = [];

  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = DateFormat('dd/MM/yyyy').format(date);

    notifyListeners();
  }

  /// [setTime] for setting time of Todo
  void setTime(TimeOfDay time, BuildContext context) {
    selectedTime = time;
    timeController.text = time.format(context);
    notifyListeners();
  }

  void addSubTask() {
    subTaskControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeSubTask(int index) {
    subTaskControllers.removeAt(index);
    notifyListeners();
  }

  Future<void> createTodo(BuildContext context) async {
    try {
      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter title and description')),
        );
        return;
      }
      var uuid = Uuid();
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      var todoModel = TodoModel(
        title: titleController.text,
        description: descriptionController.text,
        createdAt: DateTime.now(),
        dueDate: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
        id: uuid.v4(),

        userEmail: userEmail ?? '',
        sharedWith: [],

        isCompleted: false,

        subTasks:
            subTaskControllers
                .where((element) => element.text.isNotEmpty)
                .map(
                  (e) => SubTask(
                    title: e.text,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                  ),
                )
                .toList(),
      );

      await FirebaseFirestore.instance
          .collection('todos')
          .doc(todoModel.id)
          .set(todoModel.toMap());

      addTodo(TodoModel.fromMap(todoModel.toMap()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo created successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      clear();
    }
  }

  void clear() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    timeController.clear();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now().replacing(
      minute: TimeOfDay.now().minute < 58 ? TimeOfDay.now().minute + 2 : 0,
      hour:
          TimeOfDay.now().minute < 58
              ? TimeOfDay.now().hour
              : TimeOfDay.now().hour + 1,
    );

    subTaskControllers.clear();
    notifyListeners();
  }

  void toggleSubTaskCompletion(String todoId, int subTaskIndex) {
    final todo = _todos.firstWhere((element) => element.id == todoId);

    final updatedSubTask = SubTask(
      title: todo.subTasks[subTaskIndex].title,
      isCompleted: !todo.subTasks[subTaskIndex].isCompleted,
      createdAt: todo.subTasks[subTaskIndex].createdAt,
    );

    todo.subTasks[subTaskIndex] = updatedSubTask;

    // Check if all subtasks are completed
    final allSubTasksCompleted = todo.subTasks.every(
      (subtask) => subtask.isCompleted,
    );

    // Update the todo completion status
    todo.isCompleted = allSubTasksCompleted;

    FirebaseFirestore.instance.collection('todos').doc(todoId).update({
      'subTasks':
          todo.subTasks
              .map(
                (e) => {
                  'title': e.title,
                  'isCompleted': e.isCompleted,
                  'createdAt': e.createdAt,
                },
              )
              .toList(),
      'isCompleted': todo.isCompleted,
    });

    notifyListeners();
  }

  Future<void> fetchUserTodos() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) return;

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('todos')
              .where('userEmail', isEqualTo: userEmail)
              .get();

      _todos.clear();
      for (var doc in querySnapshot.docs) {
        _todos.add(TodoModel.fromMap(doc.data()));
      }

      notifyListeners();
    } catch (e) {
      log('Error fetching user todos: $e');
    }
  }

  // Sharing a todo with another user

  Future<void> shareTodo(String todoId, List<String> sharedUsers) async {
    log('message******: $todoId');
    log('message****************: $sharedUsers');
    try {
      FirebaseFirestore.instance.collection('todos').doc(todoId).update({
        'sharedWith': FieldValue.arrayUnion(sharedUsers),
      });

      notifyListeners();
    } catch (e) {
      log('Error sharing todo: $e');
    }
  }

  Future<void> fetchSharedTodos() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('todos')
              .where('sharedWith', arrayContains: userEmail)
              .get();

      log('Current user: $userEmail');
      log('Fetched ${querySnapshot.docs.length} shared todos');

      for (var doc in querySnapshot.docs) {
        final data = TodoModel.fromMap(doc.data());
        if (!_todos.any((t) => t.id == data.id)) {
          _todos.add(data);
        }
      }

      notifyListeners();
    } catch (e) {
      log('Error fetching shared todos: $e');
    }
  }

  Future<void> deleteSharedTodo(String todoId) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      await FirebaseFirestore.instance.collection('todos').doc(todoId).update({
        'sharedWith': FieldValue.arrayRemove([userEmail]),
      });

      _todos.removeWhere((todo) => todo.id == todoId);
      notifyListeners();
    } catch (e) {
      log('Error deleting shared todo: $e');
    }
  }

  // Future<void> shareTodoWithUsers({
  //   required String todoId,
  //   required List<SharedModel> sharedUsers,
  // }) async {
  //   try {
  //     final todoRef = FirebaseFirestore.instance
  //         .collection('todos')
  //         .doc(todoId);

  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       final snapshot = await transaction.get(todoRef);
  //       if (!snapshot.exists) {
  //         log('Todo with id $todoId does not exist.');
  //         return;
  //       }

  //       final currentSharedWith = List<Map<String, dynamic>>.from(
  //         snapshot['sharedWith'] ?? [],
  //       );

  //       final updatedSharedWith = [
  //         ...currentSharedWith,
  //         ...sharedUsers.map((user) => user.toMap()),
  //       ];

  //       transaction.update(todoRef, {'sharedWith': updatedSharedWith});
  //       log('Updated sharedWith: $updatedSharedWith');
  //     });

  //     final todo = _todos.firstWhere((element) => element.id == todoId);
  //     todo.sharedWith = [
  //       ...todo.sharedWith,
  //       ...sharedUsers.map((user) => user.sharedBy),
  //     ];
  //     notifyListeners();
  //   } catch (e) {
  //     log('Error sharing todo with multiple users: $e');
  //   }
  // }

  // Future<void> fetchSharedTodos() async {
  //   try {
  //     final userEmail = FirebaseAuth.instance.currentUser?.email;

  //     if (userEmail == null) return;

  //     final querySnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('todos')
  //             .where(
  //               'sharedWith',
  //               arrayContains: userEmail,
  //             ) // Query todos shared with the current user
  //             .get();

  //     log('Current user: $userEmail');
  //     log('Fetched ${querySnapshot.docs.length} todos');

  //     for (var doc in querySnapshot.docs) {
  //       final data = SharedModel.fromMap(doc.data());
  //       log('data.toString()********: ${data.toString()}');
  //       // final data = doc.data();
  //       // final todo = TodoModel(
  //       //   id: doc.id,
  //       //   title: data['title'],
  //       //   description: data['description'],
  //       //   createdAt: (data['createdAt'] as Timestamp).toDate(),
  //       //   dueDate: (data['dueDate'] as Timestamp).toDate(),
  //       //   isCompleted: data['isCompleted'],
  //       //   userEmail: data['userEmail'],
  //       //   sharedWith: List<String>.from(data['sharedWith'] ?? []),
  //       //   subTasks:
  //       //       (data['subTasks'] as List<dynamic>)
  //       //           .map(
  //       //             (e) => SubTask(
  //       //               title: e['title'],
  //       //               isCompleted: e['isCompleted'],
  //       //               createdAt: (e['createdAt'] as Timestamp).toDate(),
  //       //             ),
  //       //           )
  //       //           .toList(),
  //       // );
  //       // if (!_todos.any((t) => t.id == todo.id)) {
  //       //   _todos.add(
  //       //     todo,
  //       //   ); // Add shared todo to the local list if not already present
  //       // }
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     log('Error fetching shared todos: $e');
  //   }
  // }
}

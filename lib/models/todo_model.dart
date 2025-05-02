// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

enum Priority {
  low(color: Colors.blue, icon: IconsaxPlusLinear.info_circle, text: 'Low'),
  medium(
    color: Colors.orange,
    icon: IconsaxPlusLinear.warning_2,
    text: 'Medium',
  ),
  high(color: Colors.red, icon: IconsaxPlusLinear.information, text: 'High');

  const Priority({required this.color, required this.icon, required this.text});
  final String text;
  final Color color;
  final IconData icon;
}

enum AccessRights {
  view(
    value: 'view',
    title: 'View',
    description: 'View all the details of the todo',
  ),
  edit(
    value: 'edit',
    title: 'Edit',
    description: 'Edit all the details of the todo',
  ),
  admin(
    value: 'admin',
    title: 'Admin',
    description:
        'Edit all the details of the todo, add and remove shared users, delete subtasks',
  );

  const AccessRights({
    required this.value,
    required this.title,
    required this.description,
  });
  final String value;
  final String title;
  final String description;
}

@immutable
class TodoModel {
  final String id;
  final String title;
  final String description;
  // final Priority priority;
  final DateTime dueDate;
  final List<SubTask> subTasks;
  bool isCompleted;
  final DateTime createdAt;
  final String userEmail;
  final bool isAddedInCalendar;
  final String eventId;
  final bool isPinned;
  final bool isNotificationPinned;
  final bool isNotificationScheduled;
  final int? notificationId;
  final int? notificationScheduleId;
  final int notifyBefore;
  final List<String> sharedWith;
  final List<SharedModel> shareDetails;
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    // required this.priority,
    required this.dueDate,
    required this.subTasks,
    required this.isCompleted,
    required this.createdAt,
    required this.userEmail,
    this.isAddedInCalendar = false,
    this.eventId = '',
    this.isPinned = false,
    this.isNotificationPinned = false,
    this.isNotificationScheduled = false,
    this.notificationId,
    this.notificationScheduleId,
    this.notifyBefore = 0,
    required this.sharedWith,
    this.shareDetails = const [],
  });

  // Add empty constructor
  factory TodoModel.empty() {
    return TodoModel(
      id: '',
      title: '',
      description: '',
      // priority: Priority.low,
      dueDate: DateTime.now(),
      subTasks: const [],
      isCompleted: false,
      createdAt: DateTime.now(),
      userEmail: '',
      isAddedInCalendar: false,
      eventId: '',
      isPinned: false,
      isNotificationPinned: false,
      isNotificationScheduled: false,
      notificationId: null,
      notificationScheduleId: null,
      notifyBefore: 0,
      sharedWith: const [],
      shareDetails: const [],
    );
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? dueDate,
    List<SubTask>? subTasks,
    bool? isCompleted,
    DateTime? createdAt,
    String? userEmail,
    bool? isAddedInCalendar,
    String? eventId,
    bool? isPinned,
    bool? isNotificationPinned,
    bool? isNotificationScheduled,
    int? notificationId,
    int? notificationScheduleId,
    int? notifyBefore,
    List<String>? sharedWith,
    List<SharedModel>? shareDetails,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      // priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      subTasks: subTasks ?? this.subTasks,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userEmail: userEmail ?? this.userEmail,
      isAddedInCalendar: isAddedInCalendar ?? this.isAddedInCalendar,
      eventId: eventId ?? this.eventId,
      isPinned: isPinned ?? this.isPinned,
      isNotificationPinned: isNotificationPinned ?? this.isNotificationPinned,
      isNotificationScheduled:
          isNotificationScheduled ?? this.isNotificationScheduled,
      notificationId: notificationId ?? this.notificationId,
      notificationScheduleId:
          notificationScheduleId ?? this.notificationScheduleId,
      notifyBefore: notifyBefore ?? this.notifyBefore,
      sharedWith: sharedWith ?? this.sharedWith,
      shareDetails: shareDetails ?? this.shareDetails,
    );
  }

  Map<String, dynamic> toMap({bool isFromJson = false}) {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      // 'priority': priority.name,
      'dueDate':
          isFromJson
              ? dueDate.millisecondsSinceEpoch
              : Timestamp.fromDate(dueDate),
      'subTasks': subTasks.map((x) => x.toMap(isFromJson: isFromJson)).toList(),
      'isCompleted': isCompleted,
      'createdAt':
          isFromJson
              ? createdAt.millisecondsSinceEpoch
              : Timestamp.fromDate(createdAt),
      'userEmail': userEmail,
      'isAddedInCalendar': isAddedInCalendar,
      'eventId': eventId,
      'isPinned': isPinned,
      'isNotificationPinned': isNotificationPinned,
      'isNotificationScheduled': isNotificationScheduled,
      'notificationId': notificationId,
      'notificationScheduleId': notificationScheduleId,
      'notifyBefore': notifyBefore,
      'sharedWith': sharedWith,
      'shareDetails': shareDetails.map((e) => e.toMap()).toList(),
    };
  }

  factory TodoModel.fromMap(
    Map<String, dynamic> map, {
    bool isFromJson = false,
  }) {
    final sharedWith = List<String>.from(
      map['sharedWith'] as List<dynamic>? ?? [],
    );
    final shareDetails = List<SharedModel>.from(
      (map['shareDetails'] as List<dynamic>? ?? <Map<String, dynamic>>[]).map(
        (e) => SharedModel.fromMap(e),
      ),
    );

    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      // priority: Priority.values.firstWhere(
      //   (e) => e.name == map['priority'] as String?,
      //   orElse: () => Priority.low,
      // ),
      dueDate:
          isFromJson
              ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
              : (map['dueDate'] as Timestamp).toDate(),
      subTasks: List<SubTask>.from(
        (map['subTasks'] as List).map<SubTask>(
          (e) => SubTask.fromMap(
            e as Map<String, dynamic>,
            isFromJson: isFromJson,
          ),
        ),
      ),
      isCompleted: map['isCompleted'] as bool,
      createdAt:
          isFromJson
              ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
              : (map['createdAt'] as Timestamp).toDate(),
      userEmail: map['userEmail'] as String,
      isAddedInCalendar: map['isAddedInCalendar'] as bool? ?? false,
      eventId: map['eventId'] as String? ?? '',
      isPinned: map['isPinned'] as bool? ?? false,
      isNotificationPinned: map['isNotificationPinned'] as bool? ?? false,
      isNotificationScheduled: map['isNotificationScheduled'] as bool? ?? false,
      notificationId: map['notificationId'] as int? ?? 0,
      notificationScheduleId: map['notificationScheduleId'] as int? ?? 0,
      notifyBefore: map['notifyBefore'] as int? ?? 0,
      sharedWith: sharedWith,
      shareDetails: shareDetails,
    );
  }

  String toJson() => json.encode(toMap(isFromJson: true));

  factory TodoModel.fromJson(String source) => TodoModel.fromMap(
    json.decode(source) as Map<String, dynamic>,
    isFromJson: true,
  );

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, description: $description, dueDate: $dueDate, subTasks: $subTasks, isCompleted: $isCompleted, createdAt: $createdAt, userEmail: $userEmail, isAddedInCalendar: $isAddedInCalendar, eventId: $eventId, isPinned: $isPinned, isNotificationPinned: $isNotificationPinned, isNotificationScheduled: $isNotificationScheduled, notificationId: $notificationId, notificationScheduleId: $notificationScheduleId, notifyBefore: $notifyBefore, sharedWith: $sharedWith, shareDetails: $shareDetails )';
  }

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        // other.priority == priority &&
        other.dueDate == dueDate &&
        listEquals(other.subTasks, subTasks) &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        other.userEmail == userEmail &&
        other.isAddedInCalendar == isAddedInCalendar &&
        other.eventId == eventId &&
        other.isPinned == isPinned &&
        other.isNotificationPinned == isNotificationPinned &&
        other.isNotificationScheduled == isNotificationScheduled &&
        other.notificationId == notificationId &&
        other.notificationScheduleId == notificationScheduleId &&
        other.notifyBefore == notifyBefore &&
        listEquals(other.sharedWith, sharedWith) &&
        listEquals(other.shareDetails, shareDetails);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        // priority.hashCode ^
        dueDate.hashCode ^
        subTasks.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode ^
        userEmail.hashCode ^
        isAddedInCalendar.hashCode ^
        eventId.hashCode ^
        isPinned.hashCode ^
        isNotificationPinned.hashCode ^
        isNotificationScheduled.hashCode ^
        notificationId.hashCode ^
        notificationScheduleId.hashCode ^
        notifyBefore.hashCode ^
        sharedWith.hashCode ^
        shareDetails.hashCode;
  }
}

@immutable
class SubTask {
  SubTask({
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });
  final String title;
  bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  SubTask copyWith({
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SubTask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap({bool isFromJson = false}) {
    return <String, dynamic>{
      'title': title,
      'isCompleted': isCompleted,
      'createdAt':
          isFromJson
              ? createdAt.millisecondsSinceEpoch
              : Timestamp.fromDate(createdAt),
      'completedAt':
          completedAt == null
              ? null
              : isFromJson
              ? completedAt!.millisecondsSinceEpoch
              : Timestamp.fromDate(completedAt!),
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map, {bool isFromJson = false}) {
    return SubTask(
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
      createdAt:
          map['createdAt'] == null
              ? DateTime.now()
              : isFromJson
              ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
              : (map['createdAt'] as Timestamp).toDate(),
      completedAt:
          map['completedAt'] == null
              ? null
              : isFromJson
              ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int)
              : (map['completedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubTask.fromJson(String source) => SubTask.fromMap(
    json.decode(source) as Map<String, dynamic>,
    isFromJson: true,
  );

  @override
  String toString() =>
      'SubTask(title: $title, isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt)';

  @override
  bool operator ==(covariant SubTask other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode ^
      completedAt.hashCode;
}

class SharedModel {
  final String sharedWith;
  final String sharedBy;
  final AccessRights accessRights;
  const SharedModel({
    required this.sharedWith,
    required this.sharedBy,
    required this.accessRights,
  });

  SharedModel copyWith({
    String? sharedWith,
    String? sharedBy,
    AccessRights? accessRights,
  }) {
    return SharedModel(
      sharedWith: sharedWith ?? this.sharedWith,
      sharedBy: sharedBy ?? this.sharedBy,
      accessRights: accessRights ?? this.accessRights,
    );
  }

  Map<String, dynamic> toMap({bool isFromJson = false}) {
    return <String, dynamic>{
      'sharedWith': sharedWith,
      'sharedBy': sharedBy,
      'accessRights': accessRights.value,
    };
  }

  factory SharedModel.fromMap(Map<String, dynamic> map) {
    return SharedModel(
      sharedWith: map['sharedWith'] as String,
      sharedBy: map['sharedBy'] as String,
      accessRights: AccessRights.values.firstWhere(
        (e) => e.value == map['accessRights'] as String,
        orElse: () => AccessRights.view,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedModel.fromJson(String source) =>
      SharedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SharedModel(sharedWith: $sharedWith, sharedBy: $sharedBy, accessRights: $accessRights)';

  @override
  bool operator ==(covariant SharedModel other) {
    if (identical(this, other)) return true;

    return other.sharedWith == sharedWith &&
        other.sharedBy == sharedBy &&
        other.accessRights == accessRights;
  }

  @override
  int get hashCode =>
      sharedWith.hashCode ^ sharedBy.hashCode ^ accessRights.hashCode;
}

class SharedTodoModel extends TodoModel {
  SharedTodoModel({
    required super.id,
    required super.title,
    required super.description,
    // required super.priority,
    required super.dueDate,
    required super.subTasks,
    required super.isCompleted,
    required super.createdAt,
    required super.userEmail,
    super.isAddedInCalendar = false,
    super.eventId = '',
    super.isPinned = false,
    super.isNotificationPinned = false,
    super.isNotificationScheduled = false,
    super.notificationId,
    super.notificationScheduleId,
    super.notifyBefore = 0,
    super.sharedWith = const [],
    required super.shareDetails,
  });

  factory SharedTodoModel.fromTodoModel(TodoModel todoModel) {
    return SharedTodoModel(
      id: todoModel.id,
      title: todoModel.title,
      description: todoModel.description,
      // priority: todoModel.priority,
      dueDate: todoModel.dueDate,
      subTasks: todoModel.subTasks,
      isCompleted: todoModel.isCompleted,
      createdAt: todoModel.createdAt,
      userEmail: todoModel.userEmail,
      shareDetails: todoModel.shareDetails,
      eventId: todoModel.eventId,
      isPinned: todoModel.isPinned,
      isAddedInCalendar: todoModel.isAddedInCalendar,
      isNotificationPinned: todoModel.isNotificationPinned,
      isNotificationScheduled: todoModel.isNotificationScheduled,
      notificationId: todoModel.notificationId,
      notificationScheduleId: todoModel.notificationScheduleId,
      notifyBefore: todoModel.notifyBefore,
      sharedWith: todoModel.sharedWith,
    );
  }

  TodoModel toTodoModel() {
    return this;
  }
}

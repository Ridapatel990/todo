// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  // final String? photoUrl;
  bool loading;
  bool hasError;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    // this.photoUrl,
    this.loading = false,
    this.hasError = false,
  });

  bool get isEmpty => id.isEmpty;

  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      // photoUrl: '',
      loading: false,
      hasError: false,
    );
  }

  factory UserModel.loading() {
    return UserModel.empty().copyWith(loading: true);
  }

  factory UserModel.error() {
    return UserModel.empty().copyWith(hasError: true);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      // photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email;
    // other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    // String? photoUrl,
    bool? loading,
    bool? hasError,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      // photoUrl: photoUrl ?? this.photoUrl,
      loading: loading ?? this.loading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, loading: $loading, hasError: $hasError)';
  }

  static UserModel of(BuildContext context, {bool listen = true}) {
    return Provider.of<UserModel>(context, listen: listen);
  }
}

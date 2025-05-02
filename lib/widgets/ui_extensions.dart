import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Extension for num to get [SizedBox] with height, width and square
extension UIExtensions on num {
  Gap get g => Gap(toDouble());

  /// Returns [SizedBox] with height
  ///
  /// Example:
  /// ```dart
  /// 10.h
  /// ```
  SizedBox get h => SizedBox(height: toDouble());

  /// Returns [SizedBox] with width
  ///
  /// Example:
  /// ```dart
  /// 10.w
  /// ```
  SizedBox get w => SizedBox(width: toDouble());

  /// Returns [SizedBox] with height and width
  ///
  /// Example:
  /// ```dart
  /// 10.sq
  /// ```
  SizedBox get sq => SizedBox.square(dimension: toDouble());

  /// Returns [EdgeInsets] with all sides
  ///
  /// Example:
  /// ```dart
  /// 10.pa
  /// ```
  EdgeInsets get pa => EdgeInsets.all(toDouble());

  /// Returns [EdgeInsets] with horizontal
  ///
  /// Example:
  /// ```dart
  /// 10.ph
  /// ```
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: toDouble());

  /// Returns [EdgeInsets] with vertical
  ///
  /// Example:
  /// ```dart
  /// 10.pv
  /// ```
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: toDouble());

  /// Returns [EdgeInsets] with top
  ///
  /// Example:
  /// ```dart
  /// 10.pt
  /// ```
  EdgeInsets get pt => EdgeInsets.only(top: toDouble());

  /// Returns [EdgeInsets] with left
  ///
  /// Example:
  /// ```dart
  /// 10.pl
  /// ```
  EdgeInsets get pl => EdgeInsets.only(left: toDouble());

  /// Returns [EdgeInsets] with right
  ///
  /// Example:
  /// ```dart
  /// 10.pr
  /// ```
  EdgeInsets get pr => EdgeInsets.only(right: toDouble());

  /// Returns [EdgeInsets] with bottom
  ///
  /// Example:
  /// ```dart
  /// 10.pb
  /// ```
  EdgeInsets get pb => EdgeInsets.only(bottom: toDouble());

  /// Returns [EdgeInsets] with symmetric
  EdgeInsets symmetric({double? vertical, double? horizontal}) =>
      EdgeInsets.symmetric(
        vertical: vertical ?? toDouble(),
        horizontal: horizontal ?? toDouble(),
      );
}

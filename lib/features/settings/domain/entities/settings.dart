import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final bool isStartup;
  final ThemeMode themeMode;

  const Settings({required this.isStartup, required this.themeMode});

  @override
  List<Object?> get props => [isStartup, themeMode];
}

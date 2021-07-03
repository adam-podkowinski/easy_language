import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings with EquatableMixin {
  bool isStartup;
  ThemeMode themeMode;

  Settings({this.isStartup = true, this.themeMode = ThemeMode.system});

  @override
  List<Object?> get props => [isStartup, themeMode];
}

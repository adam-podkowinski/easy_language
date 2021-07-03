import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final bool isStartup;
  final ThemeMode themeMode;

  const Settings({this.isStartup = true, this.themeMode = ThemeMode.system});

  @override
  List<Object?> get props => [isStartup, themeMode];
}

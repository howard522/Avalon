import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 提供全局淺色／深色模式
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
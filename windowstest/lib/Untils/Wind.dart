import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:window_manager/window_manager.dart';


class WindowUtil {
  static void init({required double width, required double height}) async {
    WindowOptions windowOptions = WindowOptions(
      size: Size(1200, 700),
      minimumSize: Size(120, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();

    });
  }

  static void setResizable(bool reSize) {
    windowManager.setResizable(reSize);
  }

  static void StartEXE() async {
    Directory currentDir = Directory.current;
    String currentPath = currentDir.path;

    print('当前文件夹路径：$currentPath/main.exe');
    String exePath ="$currentPath/main.exe";
    // String exePath = 'path/to/your/executable.exe'; // 替换为实际的可执行文件路径
    ProcessResult result = await Process.run(exePath, []);
    if (result.exitCode == 0) {
      print('成功启动可执行文件');
    } else {
      print('启动可执行文件时出错：${result.stderr}');
    }
  }


}
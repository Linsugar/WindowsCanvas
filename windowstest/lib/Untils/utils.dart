import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final xType = XTypeGroup(label: '图片', extensions: ['jpg', 'png']);

//获取本地图片
Future<String?> GetPhoto()async{
  final XFile? file = await openFile(acceptedTypeGroups: [xType]);
  var  value = file?.path;
  if (value==null){
    print("没有图片");
  }
  print("得到的图片地址：${value}");
  return value;
}


class ShowToast{

  static var LoadingCancel;


  static initToast(){
    return EasyLoading.init();
  }

  static ShowLoading(){
    EasyLoading.show(status: 'loading...');
  }

  static CancelLoading(){
    EasyLoading.dismiss();
  }

  static ShowToastText(String text){
    EasyLoading.showToast(text);
  }



}

TextStyle ReturnStyle(){
  TextStyle textStyle =  TextStyle(
    fontFamily: "Regular"
  );
  return textStyle;
}
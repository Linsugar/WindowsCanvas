import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowstest/Untils/Wind.dart';
import 'NetWork/Request.dart';
import 'Untils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  WindowUtil.setResizable(false);
  WindowUtil.StartEXE();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Colors.black)),
      home: const MyHomePage(),
    );
  }
}





class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController PhotoPath = TextEditingController();
  TextEditingController RtspPath = TextEditingController();
  TextEditingController Areas = TextEditingController();
  TextEditingController Width = TextEditingController(text: "1920");
  TextEditingController Height = TextEditingController(text: "1080");
  String? LocalPath = null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TopButtonEvent(RtspPath, "请输入rtsp流地址"),
                        TextButton(onPressed: () async{
                         var value =  await GetRtspPhoto();
                         if (value["result"]!=null){
                           setState(() {
                             LocalPath = value["result"];
                             PhotoPath.text = LocalPath!;
                           });
                         }
                         print(value);
                        }, child: Text("检测",style: TextStyle(
                          fontFamily: "Regular"
                        ),))
                      ],
                    ),
                    Row(
                      children: [
                        TopButtonEvent(PhotoPath, "请输入本地图片地址或上传"),
                        TextButton(onPressed: () async{
                          var result  =  await GetPhoto();
                          if (result!=null){
                            setState(() {
                              PhotoPath.text = result;
                              LocalPath = result;
                            });

                          }
                        }, child: Text("上传",style: TextStyle(
                            fontFamily: "Regular"
                        )))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("警戒框坐标系：",style: TextStyle(
                              fontFamily: "Regular"
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 300,
                            height: 200,
                            child: TextFormField(
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "该为必填";
                                }
                                return null;
                              },
                              controller: Areas,
                              maxLines: 50,
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("分辨率：",style: TextStyle(
                              fontFamily: "Regular",
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 70,
                                height: 40,
                                child: TextFormField(
                                  maxLines: 1,
                                  maxLength: 4,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value){
                                    Width.text = value;
                                  },
                                  decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "宽",
                                      hintStyle: TextStyle(
                                      fontFamily: "Regular"
                                  ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FaIcon(FontAwesomeIcons.xmark),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 70,
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  maxLength: 4,
                                  onChanged: (value){
                                    Height.text = value;
                                  },
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: "高",
                                    hintStyle: TextStyle(
                                      fontFamily: "Regular"
                                  ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 50,
                          child: TextButton(
                            onPressed: () async{
                              if(_formKey.currentState!.validate() && PhotoPath.text.isNotEmpty ){
                                var value =  await LocalCanvasPhoto();
                                print("value=== ${value}");
                                if(value==null){
                                  ShowToast.ShowToastText("请输入二维数组");
                                  return;
                                }
                                if(value["status"]==400){
                                  ShowToast.ShowToastText(value["result"]);
                                  return;
                                }
                                setState(() {
                                  LocalPath = value["result"];
                                  PhotoPath.text = LocalPath!;
                                });
                              }else{
                                ShowToast.ShowToastText("请把所有的内容都填写");

                              }

                            },
                            child: Text("开始校验",style: TextStyle(
                                fontFamily: "Regular",
                              fontSize: 20
                            )),
                          ),
                        ),
                        Container(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                RtspPath.text = "";
                                Areas.text = "";
                                Width.text = "";
                                Height.text = "";
                                PhotoPath.text = "";
                                LocalPath = null;
                              });
                            },
                            child: Text("重置",style: TextStyle(
                                fontFamily: "Regular"
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            await ClearLocal();
                            setState(() {
                              RtspPath.text = "";
                              Areas.text = "";
                              Width.text = "";
                              Height.text = "";
                              PhotoPath.text = "";
                            });
                          },
                            child: Text("清理缓存",style: TextStyle(
                                fontFamily: "Regular"
                            ))),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(gradient: LinearGradient(
                    colors: [Colors.white24, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                )),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: LocalPath==null?Container(
              child: Center(
                child: Text("请使用rtsp流获取图或上传本地图片",style: TextStyle(
                    fontFamily: "Regular"
                )),
              ),
            ):Image.file(File(LocalPath!),fit: BoxFit.contain,)
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //根据rtsp流地址去进行的截图
  Future<Map<String,dynamic>> GetRtspPhoto() async{
    var data = {
      "rtsp":RtspPath.text
    };
    var result = await Request.setNetwork("/GetPhoto",data: data);
    print("result: $result");
    return result;
  }
//根据上传的本地地址去绘图
  Future<Map<String,dynamic>?> LocalCanvasPhoto() async{
    List<dynamic>? areas;
    bool isOk =true;
    try{
      areas = jsonDecode(Areas.text);
    }catch(e){
      print("异常：${e}");
      isOk = false;
    } finally{
      if (areas==null){
        return null;
      }
      if (areas.length>=1 && isOk){
        var data = {
          "address":LocalPath,
          "areas":areas,
          "width":int.parse(Width.text),
          "height":int.parse(Height.text),
          "rtsp":""
        };
        print("result2: $data");
        var result = await Request.setNetwork("/CheckPhoto",data: data);
        print("result: $result");
        return result;
      }
    }
  }


  //根据上传的本地地址去绘图
  Future ClearLocal() async{
      await Request.setNetwork("/clear");
    }
}

Widget TopButtonEvent(TextEditingController _controller,String _str) {
  return Container(
    child: TextFormField(
      controller: _controller,
      onChanged: (value){
        _controller.text = value;
      },
      decoration: InputDecoration(
          prefixIcon: Column(
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 15,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          border: OutlineInputBorder(),
          hintText: _str,
        hintStyle: TextStyle(
          fontFamily: "Regular"
      )
      ),
    ),
    margin: EdgeInsets.only(left: 10),
    width: 270,
    height: 60,
  );
}

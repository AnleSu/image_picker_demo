import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'yz_imagePicker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

class StartDrivePage extends StatefulWidget {
  final String orderNo; //退车单号
  final String customerName; // 客户名
  const StartDrivePage({Key key, this.orderNo, this.customerName})
      : super(key: key);
  @override
  _StartDrivePageState createState() => _StartDrivePageState();
}

class _StartDrivePageState extends State<StartDrivePage> {
  TextEditingController _licenseController = new TextEditingController();
  TextEditingController _kmController = new TextEditingController();
  final FocusNode _nodeLicense = FocusNode();
  final FocusNode _nodeKm = FocusNode();
  Widget _getBody() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
            child: ListView(
          children: <Widget>[
           
            SizedBox(
              height: 10,
            ),
            UcarImagePicker(
              maxCount: 3,
              title: '上传图片测试1',
            ),
            Divider(
              height: 1,
            ),
            UcarImagePicker(
              maxCount: 5,
              title: '上传图片测试222',
            ),
            CachedNetworkImage(
              imageUrl: "http://via.placeholder.com/350x150",
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ],
        )),
        SafeArea(
          child: MaterialButton(
            height: 46,
            color: Color(0xFFF12E49),
            textColor: Colors.white,
            child: Text(
              "立即开始",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            onPressed: ()  async {
              final cameras = await availableCameras();

              // Get a specific camera from the list of available cameras.
              final firstCamera = cameras.first;
               Navigator.push(context, MaterialPageRoute(
                   builder: (context) {
                     return TakePictureScreen(camera:firstCamera,);
                   }
               ));
            },
          ),
        )
      ],
    ));
  }

  

  _listener() {
    
    print("${_kmController.text}");
    print("${_licenseController.text}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _licenseController.addListener(_listener);
    _kmController.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('上传图片测试'),
            
          ),
          body: _getBody(),
        ));
  }
}

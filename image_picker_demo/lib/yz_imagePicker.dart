import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'bottom_sheet.dart';

enum PickImageType {
  gallery,
  camera,
}

class UploadImageModel {
  final File imageFile;
  final int imageIndex;

  UploadImageModel(this.imageFile, this.imageIndex);
}

class UploadImageItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Function callBack;
  final UploadImageModel imageModel;
  final Function deleteFun;
  UploadImageItem({this.onTap, this.callBack, this.imageModel, this.deleteFun});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 115,
        height: 115,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(0xFFF0F0F0)),
                child: imageModel == null
                    ? InkWell(
                        onTap: onTap ??
                            () {
                              BottomActionSheet.show(context, [
                                '相机',
                                '相册',
                              ], callBack: (i) {
                                callBack(i);

                                return;
                              });
                            },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'resources/image_picker.png',
                              ),
                            ),
                            Text(
                              '上传',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff999999)),
                            )
                          ],
                        ))
                    : Image.file(
                        imageModel.imageFile,
                        width: 105,
                        height: 105,
                      )),
            Offstage(
              offstage: (imageModel == null),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Image.asset(
                  'resources/删除图片.png',
                  width: 16.0,
                  height: 16.0,
                ),
                onTap: () {
                  print('点击了删除');
                  if (imageModel != null) {
                    deleteFun(this);
                  }
                },
              ),
            ),
          ],
        ));
  }
}

class UcarImagePicker extends StatefulWidget {
  final String title;
  final int maxCount;

  UcarImagePicker({this.title, this.maxCount});
  @override
  _UcarImagePickerState createState() => _UcarImagePickerState();
}

class _UcarImagePickerState extends State<UcarImagePicker> {
  List _images = []; //保存添加的图片
  int currentIndex = 0;
  bool isDelete = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images.add(UploadImageItem(
      callBack: (int i) {
        if (i == 0) {
          print('打开相机');
          _getImage(PickImageType.camera);
        } else {
          print('打开相册');
          _getImage(PickImageType.gallery);
        }
      },
    ));
  }

  _getImage(PickImageType type) async {
    var image = await ImagePicker.pickImage(
        source: type == PickImageType.gallery
            ? ImageSource.gallery
            : ImageSource.camera);
    UploadImageItem();
    setState(() {
      print('add image at $currentIndex');
      _images.insert(
          _images.length - 1,
          UploadImageItem(
            imageModel: UploadImageModel(image, currentIndex),
            deleteFun: (UploadImageItem item) {
              print('remove image at ${item.imageModel.imageIndex}');
              bool result = _images.remove(item);
              print('left is ${_images.length}');
              if (_images.length == widget.maxCount -1 && isDelete == false) {
                isDelete = true;
                _images.add(UploadImageItem(
                  callBack: (int i) {
                    if (i == 0) {
                      print('打开相机');
                      _getImage(PickImageType.camera);
                    } else {
                      print('打开相册');
                      _getImage(PickImageType.gallery);
                    }
                  },
                ));
              }
              print('remove result is $result');
              setState(() {});
            },
          ));
      currentIndex++;
      if (_images.length == widget.maxCount + 1) {
        _images.removeLast();
        isDelete = false;
      }
    });
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    UploadImageItem();
    setState(() {
      _images.insert(
          _images.length - 1,
          UploadImageItem(
            imageModel: UploadImageModel(image, currentIndex),
          ));
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _images.insert(
        _images.length - 1,
        UploadImageItem(
          imageModel: UploadImageModel(image, currentIndex),
        ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: 14, left: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 10,
            children: List.generate(_images.length, (i) {
              return _images[i];
            }),
          )
        ],
      ),
    );
  }
}

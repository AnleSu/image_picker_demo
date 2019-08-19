import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class TakePictureScreen extends StatefulWidget {

  final CameraDescription camera;
  const TakePictureScreen({
    Key key,
    @required this.camera,
}): super(key: key);
  @override
  TakePictureScreenState createState() {
    // TODO: implement createState
    return  TakePictureScreenState();
  }

}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _cameraController;
  Future<void> _initialzeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.max
    );
    _initialzeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("take a picture"),),
      body:  FutureBuilder(
        future: _initialzeControllerFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
          onPressed: () async{
            try {
              await _initialzeControllerFuture;
              final path = join(
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png'
              );
              await _cameraController.takePicture(path);
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => DisplayPictureScreen(imagePath: path)
              )
              );
                  
            } catch (e){

            }
          }),
    );

  }

}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
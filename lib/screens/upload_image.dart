import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../providers/data_providers.dart';
import 'package:provider/provider.dart';

class Uploader extends StatefulWidget {
  static const routeName = '/uploadImage';

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://khakiji-meelhk2001.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  Future<void> startUpload(
    File file,
    String id,
  ) async {
    /// Unique file name for the file
    String filePath = 'images/${id}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(file);
    });
    //if(_uploadTask.isComplete){await uploadOnDatabase;print('Now its done bro..............');}
  }

  @override
  Widget build(BuildContext context) {
    ImageCards imageCard = ModalRoute.of(context).settings.arguments;
    //final uploadOnDatabase = Provider.of<DataProviders>(context, listen: false).uploadOnDatabase;
    if (_uploadTask == null) {
      startUpload(
        imageCard.image,
        imageCard.id,
      );
    }

    /// Manage the task state and event subscription with a StreamBuilder
    return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (_, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: Column(
                children: [
                  if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),

                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),

                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                  SizedBox(
                    height: 20,
                  ),
                  if (_uploadTask.isComplete)
                    FlatButton(
                        onPressed: () {
                          Provider.of<DataProviders>(context, listen: false)
                              .uploadOnDatabase(imageCard)
                              .catchError((error) => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        content: Text('An error occured'),
                                      )))
                              .then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('प्रदर्शित करें')),
                ],
              )));
        });
    // } else {
    //   // Allows user to decide when to start the upload
    //   return Scaffold(
    //       appBar: AppBar(),
    //       body: Center(
    //           child: FlatButton.icon(
    //               label: Text('Upload to Firebase'),
    //               icon: Icon(Icons.cloud_upload),
    //               onPressed: () {
    //                 //FirebaseApp.initializeApp(this);
    //                 startUpload(imageCard.image, imageCard.id);
    //               })));
    // }
  }
}

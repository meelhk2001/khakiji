import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  Function _selectImage;
  bool isImage;
  ImageInput(this._selectImage, this.isImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  File imageFile;

  Future<void> _takePicture() async {
    if (widget.isImage) {
      imageFile = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 600);
    } else {
      imageFile = await ImagePicker.pickVideo(
          source: ImageSource.gallery, maxDuration: Duration(minutes: 5));
    }
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget._selectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    String mode = widget.isImage ? 'image' : 'video';
    return Row(
      children: <Widget>[
        if (mode == 'image')
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: _storedImage != null
                ? Image.file(
                    _storedImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
          ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Upload $mode'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}

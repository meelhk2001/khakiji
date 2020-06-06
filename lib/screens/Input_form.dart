import 'package:flutter/material.dart';
import 'dart:io';
import '../widget/input_image.dart';
import 'upload_image.dart';
import '../providers/data_providers.dart';

class InputForm extends StatefulWidget {
  static const routeName = '/Inputform';
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  File _pickedImage;
  String description;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    bool isImage = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange[600],
              backgroundImage: AssetImage('assets/images/om2.png'),
            ),
            Text('गुरुकृपा आश्रम'),
            CircleAvatar(
              backgroundColor: Colors.orange[600],
              backgroundImage: AssetImage('assets/images/om2.png'),
            )
          ],
        ),
        backgroundColor: Colors.orange[600],
        elevation: 0,
        //leading: Image.asset('assets/images/om2.png'),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ImageInput(_selectImage, isImage),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                minLines: 10,
                maxLines: 500,
                textCapitalization: TextCapitalization.sentences,
               
                decoration: InputDecoration.collapsed(hintText: ' विवरण'),
                onChanged: (val) {
                  description = val;
                },
              ),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.orange[600])),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                onPressed: () {
                  String id = DateTime.now().toIso8601String();
                  var imageUrl =
                      'https://firebasestorage.googleapis.com/v0/b/khakiji-meelhk2001.appspot.com/o/images%2f$id.png?alt=media';
                  var imageCard =
                      ImageCards(id:id, imageUrl:imageUrl, description:description, image:_pickedImage, isImage: isImage);
                  // print(imageCard.id);
                  // Provider.of<DataProviders>(context,listen: false)
                  //     .uploadOnDatabase(imageCard)
                  //     .then((value) =>
                  Navigator.of(context).popAndPushNamed(Uploader.routeName,
                      arguments: imageCard); // here ) before ;
                },
                child: Text('रक्षित करें',style: TextStyle(color: Colors.red[400],fontSize: 20),))
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ImageCards {
  String id;
  String imageUrl;
  String description;
  File image;
  bool isImage;
  ImageCards({this.id, this.imageUrl, this.description, this.image, this.isImage});
}

class DataProviders with ChangeNotifier {
  List<ImageCards> imageData = [];
  void save(ImageCards element) {
    imageData.insert(0, element);
  }

  var wait = true;

  Future<void> uploadOnDatabase(ImageCards element) async {
    print(element.id);
    imageData.insert(0, element);
    notifyListeners();
    final url = 'https://khakiji-meelhk2001.firebaseio.com/khakiji.json';

    try {
      var response = await http.post(url,
          body: json.encode({
            'id': element.id,
            'imageUrl': element.imageUrl,
            'description': element.description,
            'isImage':element.isImage,
          }));
      print('ho gya////////');
      print(imageData[0].imageUrl);

      print(jsonDecode(response.body.toString()).toString());
    } catch (error) {
      imageData.removeAt(0);
      notifyListeners();
      FirebaseStorage storage =
          FirebaseStorage(storageBucket: 'gs://khakiji-meelhk2001.appspot.com');
      var desertRef = storage.ref().child('images/${element.id}.png');
      desertRef.delete();
      //showDialoge();
      print('.........error aagi..');
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      final url = 'https://khakiji-meelhk2001.firebaseio.com/khakiji.json';
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        imageData.add(ImageCards(
         id: value['id'],
         imageUrl: value['imageUrl'],
         description: value['description'],
         isImage: value['isImage']
        ));
      });
      notifyListeners();
      print(imageData.length);
    } catch (error) {
      throw error;
    }
  }
  void removeItem(String id){
    imageData.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

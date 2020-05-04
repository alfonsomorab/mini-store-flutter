
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Keys {

  String _firebaseKey;
  String _cloudinaryUploadPreset;
  String _cloudinaryKey;

  Future<bool> initKeys() async{

    final config = await rootBundle.loadString('assets/config.json');
    final keys = json.decode(config);
    this._firebaseKey = keys['firebase_key'];
    this._cloudinaryKey = keys['cloudinary_key'];
    this._cloudinaryUploadPreset = keys['cloudinary_upload_preset'];

    return (this._firebaseKey.isNotEmpty);
  }

  get firebase => _firebaseKey;

  get cloudinaryUploadPreset => _cloudinaryUploadPreset;

  get cloudinaryKey => _cloudinaryKey;


}
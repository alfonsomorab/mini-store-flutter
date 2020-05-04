
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:ministore/src/keys/keys.dart';
import 'package:ministore/src/models/item_model.dart';

class ItemProvider {

  final String _url = 'https://fluttervarios-da5a1.firebaseio.com';
  final _keys = Keys();

  ItemProvider(){
    _keys.initKeys();
  }

  Future<bool> createItem( ItemModel item ) async{

    final url = '$_url/items.json';

    final resp = await http.post( url, body: itemModelToJson( item ) );

    final decodedData = json.decode( resp.body );

    return true;
  }


  Future<int> updateItem( ItemModel item ) async{

    final url = '$_url/items/${ item.id }.json';
    final resp = await http.put( url, body: itemModelToJson( item ) );
    return resp.statusCode;

  }

  Future<List<ItemModel>> getItems() async {

    final url = '$_url/items.json';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ItemModel> list = new List();

    if ( decodedData == null ) return [];

    decodedData.forEach(( id, item ){
      final itemTemp = ItemModel.fromJson(item);
      itemTemp.id = id;
      list.add(itemTemp);
    });

    return list;
  }

  Future<int> deleteItem( String id ) async {
    final url = '$_url/items/$id.json';
    final resp = await http.delete(url);
    print(resp.statusCode);
    return resp.statusCode;
  }

  Future<String> uploadImage( File image ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/'
      '${ _keys.cloudinaryKey }/image/upload?'
      'upload_preset=${_keys.cloudinaryUploadPreset }');

    final mimeType = mime(image.path).split('/'); // image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Oops! algo salio mal!!!!!');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];

  }
}
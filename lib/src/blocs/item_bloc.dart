import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:ministore/src/models/item_model.dart';
import 'package:ministore/src/providers/item_provider.dart';

class ItemBloc {

  final _itemsController = new BehaviorSubject<List<ItemModel>>();
  final _uploading = new BehaviorSubject<bool>();

  final _itemProvider = new ItemProvider();

  Stream<List<ItemModel>> get itemsStream => _itemsController.stream;
  Stream<bool> get uploading => _uploading.stream;


  void loadItems() async{
    final items = await _itemProvider.getItems();
    _itemsController.sink.add(items);
  }

  void addItem( ItemModel item ) async {

    _uploading.sink.add( true );
    await _itemProvider.createItem(item);
    _uploading.sink.add( false );
  }

  Future<String> uploadPhoto( File photo ) async {

    _uploading.sink.add( true );
    final link = await _itemProvider.uploadImage(photo);
    _uploading.sink.add( false );
    return link;
  }

  void editItem( ItemModel item ) async {

    _uploading.sink.add( true );
    await _itemProvider.updateItem(item);
    _uploading.sink.add( false );
  }

  void deleteItem( String id ) async {

    await _itemProvider.deleteItem( id );
  }

  dispose(){
    _itemsController?.close();
    _uploading?.close();
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ministore/src/blocs/item_bloc.dart';
import 'package:ministore/src/blocs/provider.dart';
import 'package:ministore/src/models/item_model.dart';
import 'package:ministore/src/utils/util.dart' as utils;

class ItemPage extends StatefulWidget {

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  ItemBloc itemBloc;

  ItemModel itemModel = new ItemModel();
  File photo;

  bool _uploading = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    itemBloc = Provider.itemsBloc(context);

    // Received item
    final ItemModel itemTemp = ModalRoute.of(context).settings.arguments;
    if ( itemTemp != null ){
      itemModel = itemTemp;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            onPressed: _pickPhotoFromCamera,
            icon: Icon( Icons.camera_alt ),
          ),
          IconButton(
            onPressed: _selectPhotoFromGallery,
            icon: Icon( Icons.photo_size_select_actual ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createPhoto(),
                _createName(),
                SizedBox(height: 20.0),
                _createPrice(),
                SizedBox(height: 20.0),
                _createAvailable(),
                SizedBox(height: 40.0),
                _createButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName(){
    return TextFormField(
      initialValue: itemModel.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: ( value ) => itemModel.title = value,
      validator: ( value ){
        if (value.length < 4)
          return 'Debe tener mas de 4 caracteres';
        return null;
      },
    );
  }

  Widget _createPrice(){
    return TextFormField(
      initialValue: itemModel.price.toString(),
      keyboardType: TextInputType.numberWithOptions( decimal: true ),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: ( value ) => itemModel.price = double.parse(value),
      validator: ( value ){
        if ( !utils.isNumeric(value) )
          return 'Debe ser un número';
        return null;
      },
    );
  }

  Widget _createAvailable(){

    return SwitchListTile(
      value: itemModel.available,
      onChanged: ( value ) => setState(() => itemModel.available = value) ,
      title: Text("Disponible"),


    );
  }

  Widget _createButton(){
    return Container(
      width: double.infinity,
      height: 40.0,
      child: RaisedButton.icon(

        onPressed: ( !_uploading )? _submit : null,
        textColor: Colors.white,
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),

        ),
        icon: Icon( Icons.save ),
        label: Text('Guardar'),
      ),
    );
  }

  _submit() async {

    if ( !formKey.currentState.validate() ) return;

    formKey.currentState.save();

    setState(() {
      _uploading = true;
    });

    if ( photo != null ){
      final imageURL =  await itemBloc.uploadPhoto(photo);
      itemModel.photoUrl = imageURL;
      print(imageURL);
    }

    if ( itemModel.id == null ){

      itemBloc.addItem(itemModel);
      showSnackBar('El producto de creó con éxito');
    }
    else{
      itemBloc.editItem(itemModel);
      showSnackBar('El producto de actualizó con éxito');
    }

    setState(() {
      _uploading = false;
    });

    Navigator.pop(context);
  }

  void showSnackBar( String message ){
    final snack = new SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 2000),
    );
    scaffoldKey.currentState.showSnackBar(snack);
  }


  _createPhoto(){

    if (itemModel.photoUrl != null){
      return FadeInImage(
        image: NetworkImage( itemModel.photoUrl ),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
    else{
      if ( photo != null )
        return Image.file(photo);
      else
        return Image(
          image: AssetImage('assets/no-image.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );
    }
  }

  _selectPhotoFromGallery() {

    _selectPhoto(ImageSource.gallery);
  }

  _pickPhotoFromCamera(){
    _selectPhoto(ImageSource.camera);
  }

  _selectPhoto( ImageSource origin ) async {
    photo = await ImagePicker.pickImage(
      source: origin
    );

    if ( photo != null ){
      itemModel.photoUrl = null;
    }
    setState(() {});

  }
}

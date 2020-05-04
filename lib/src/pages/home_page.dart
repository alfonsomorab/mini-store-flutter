import 'package:flutter/material.dart';
import 'package:ministore/src/blocs/provider.dart';
import 'package:ministore/src/models/item_model.dart';
import 'package:ministore/src/providers/item_provider.dart';

class HomePage extends StatelessWidget {

  final itemProvider = new ItemProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _createBody(),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createBody(){

    return FutureBuilder(
      future: itemProvider.getItems(),
      builder: (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final items = snapshot.data;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {

                return _showItem(context, items[index]);
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        }
        return Container();
      }
    );
  }
  
  Widget _showItem( BuildContext context, ItemModel item ){
    
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text('Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          )
        ),
      ),
      child: ListTile(
        title: Text('${ item.title } - ${ item.price }'),
        subtitle: Text('${ item.id }'),
        leading: Container(
          height: 50.0,
          width: 50.0,
          child: _createImage(item),
        ),
        onTap: () => Navigator.pushNamed(context, 'item', arguments: item),

      ),
      onDismissed: ( direction ){
        itemProvider.deleteItem(item.id);
      },
    );
  }

  _createImage( ItemModel item){
    if (item.photoUrl == null){
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover
      );
    }
    else{
      return FadeInImage(
        image: NetworkImage(item.photoUrl),
        placeholder: AssetImage('loading.gif'),
        fit: BoxFit.cover
      );
    }
  }

  Widget _createFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'item'),
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
    );
  }

}

import 'package:flutter/material.dart';
import 'package:products/src/blocs/provider.dart';
import 'package:products/src/models/product_model.dart';
import 'package:products/src/providers/products_provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsBloc = Provider.product(context);
    productsBloc.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page')
      ),
      body: _createProductList(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'products'),
    );
  }

  Widget _createProductList(ProductBloc productBloc) {

    return StreamBuilder(
      stream: productBloc.productStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if(snapshot.hasData) {
         final products = snapshot.data;
         return ListView.builder(
           itemCount: products.length,
           itemBuilder: (context, i) => _createProductItem(context, products[i], productBloc),
         );
       } else {
         return Center(child: CircularProgressIndicator());
       }
      },
    );
  }

  Widget _createProductItem(BuildContext context, ProductModel product, ProductBloc productBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) => productBloc.deleteProduct(product.id),
      child: Card(
        child: Column(
          children: <Widget>[
            (product.photo == null)
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(image: NetworkImage(product.photo), placeholder: AssetImage('assets/loading.gif'), height: 300.0, width: double.infinity, fit: BoxFit.cover),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text(product.id),
              onTap: () => Navigator.pushNamed(context, 'products', arguments: product),
            )
          ],
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products/src/blocs/provider.dart';
import 'package:products/src/models/product_model.dart';
import 'package:products/src/utils/utils.dart' as utils;

class ProductsPage extends StatefulWidget {

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  ProductBloc productBloc;
  ProductModel product = new ProductModel();
  bool _loading = false;
  File photo;

  @override
  Widget build(BuildContext context) {

    productBloc = Provider.product(context);
    
    final ProductModel productEdit = ModalRoute.of(context).settings.arguments;
    if(productEdit != null) product = productEdit;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _renderPhoto(),
                _renderName(),
                _renderPrice(),
                _renderAvailable(),
                _renderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product'
      ),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if(value.length < 3) return 'Write the name of the product';
        else return null;
      },
    );
  }

  Widget _renderPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (value) => product.value = double.parse(value),
      decoration: InputDecoration(
        labelText: 'Price'
      ),
      validator: (value) {
        if(utils.isNumeric(value)) return null;
        else return 'Only numbers';
      },
    );
  }

  Widget _renderAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){ product.available = value; }),
    );
  }

  Widget _renderButton(){
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      onPressed: (_loading) ? null : _submit,
      label: Text('Save'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  _renderPhoto() {
    if (product.photo != null) return FadeInImage(image: NetworkImage(product.photo), placeholder: AssetImage('assets/loading.gif'), height: 300.0, width: double.infinity, fit: BoxFit.cover);
    else {
      if( photo != null ) return Image.file(photo, fit: BoxFit.cover, height: 300.0);
      return Image.asset('assets/no-image.png');
    }
  }

  void _submit() async {
    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() { _loading = true; });

    if(photo != null) {
      product.photo = await productBloc.uploadPhoto(photo);
    }

    if(product.id == null) productBloc.createProduct(product);
    else productBloc.editProduct(product);

    showSnackbar('The data was saved');
    
    Navigator.pop(context);
  }

  void showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _selectPhoto() => _processImage(ImageSource.gallery);

  void _takePhoto() => _processImage(ImageSource.camera);

  void _processImage(ImageSource source) async {
    photo = await ImagePicker.pickImage(source: source);
    if(photo != null) product.photo = null;
    setState(() {});
  }
}
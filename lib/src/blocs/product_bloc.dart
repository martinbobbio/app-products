import 'dart:io';

import 'package:products/src/models/product_model.dart';
import 'package:products/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductProvider();

  Stream<List<ProductModel>> get productStream => _productsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void getProducts() async {
    final products = await _productsProvider.getProducts();
    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  void editProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.editProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  Future<String> uploadPhoto(File photo) async {
    _loadingController.sink.add(true);
    final photoUrl = await _productsProvider.uploadPhoto(photo);
    _loadingController.sink.add(false);
    return photoUrl;
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}
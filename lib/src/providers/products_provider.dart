import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:products/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:products/src/preferences/user_preferences.dart';

class ProductProvider {
  final String _url = 'https://flutter-9d504.firebaseio.com';
  final _prefs = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    await http.post(url, body: productModelToJson(product));

    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<ProductModel> products = new List();

    if(data == null || data['error'] != null) return [];
    data.forEach((id, product){
      final productTemp = ProductModel.fromJson(product);
      productTemp.id = id;
      products.add(productTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    await http.delete(url);

    return 1;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';
    await http.put(url, body: productModelToJson(product));

    return true;
  }

  Future<String> uploadPhoto(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dhuyjmesa/image/upload?upload_preset=tjyksdce');
    final mimeType = mime(image.path).split('/');
    final request = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', image.path, contentType: MediaType(mimeType[0], mimeType[1]));
    request.files.add(file);

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode != 200 && response.statusCode != 201) {
      print('Error');
      print(response.body);
      return null;
    }

    final data = json.decode(response.body);
    return data['secure_url'];
  }
}
import 'package:flutter/material.dart';
import 'package:products/src/blocs/provider.dart';
import 'package:products/src/pages/home_page.dart';
import 'package:products/src/pages/login_page.dart';
import 'package:products/src/pages/products_page.dart';
import 'package:products/src/pages/register_page.dart';
import 'package:products/src/preferences/user_preferences.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'products': (BuildContext context) => ProductsPage(),
          'register': (BuildContext context) => RegisterPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
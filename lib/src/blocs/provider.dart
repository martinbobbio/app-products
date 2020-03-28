import 'package:flutter/material.dart';
import 'package:products/src/blocs/product_bloc.dart';
import 'package:products/src/blocs/user_bloc.dart';
export 'package:products/src/blocs/user_bloc.dart';
import 'package:products/src/blocs/product_bloc.dart';
export 'package:products/src/blocs/product_bloc.dart';

class Provider extends InheritedWidget {

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if(_instance == null) _instance = new Provider._internal(key: key, child: child);
    return _instance;
  }

  final authBloc = new UserBloc();
  final productBloc = new ProductBloc();

  Provider._internal({Key key, Widget child}) : super(key:key, child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserBloc user(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().authBloc;
  }

  static ProductBloc product(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().productBloc;
  }
  

  
}
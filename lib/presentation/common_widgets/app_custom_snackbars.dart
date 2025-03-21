import 'package:flutter/material.dart';


appOrangeSnackBar(String message,BuildContext context)async{
  final snackBar = SnackBar(
    duration:const Duration(milliseconds: 1000),
    elevation: 2,
    backgroundColor: Colors.orange,
    content: Text(message,style: TextStyle(fontSize: 12,color: Colors.white),),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

appGreenSnackBar(String message,BuildContext context)async{
  final snackBar = SnackBar(
    duration:const Duration(milliseconds: 1000),
    elevation: 2,
    backgroundColor: Colors.green,
    content: Text(message,style: TextStyle(fontSize: 12,color: Colors.white),),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
appErrorSnackBar(String message,BuildContext context)async{
  final snackBar = SnackBar(
    duration:const Duration(milliseconds: 1000),
    elevation: 2,
    backgroundColor: Colors.red,
    content: Text(message,style: TextStyle(fontSize: 12,color: Colors.white),),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
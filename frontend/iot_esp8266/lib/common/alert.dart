import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:iot_esp8266/main.dart';


void alert(String content) {
  if(navigatorKey.currentContext!= null){
    Flushbar(
      message: content,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      messageColor: Colors.black87,
      backgroundColor: Color(0xFFFDE8EA),
      shouldIconPulse: false,
      icon:  Icon(Icons.info,size: 20,color: Colors.red,),
      borderRadius: BorderRadius.circular(4),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1500),
    ).show(navigatorKey.currentContext!);
  }
}

void notificationOpenDoor(String content) {
  if(navigatorKey.currentContext!= null){
    Flushbar(
      message: content,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      messageColor: Colors.black87,
      backgroundColor: Color(0xFFFDE8EA),
      shouldIconPulse: false,
      icon:  Icon(Icons.check,size: 20,color: Colors.greenAccent,),
      borderRadius: BorderRadius.circular(4),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1500),
    ).show(navigatorKey.currentContext!);
  }
}

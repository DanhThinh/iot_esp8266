import 'dart:async';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_esp8266/common/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionState extends ChangeNotifier {
  Timer? _timer;
  String otp = "";
  int _start = 10;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  List<String> dataNotification = [];
  String password = "";
  bool stateDoor = false;
  bool isInit = false;

  Future initData() async {
    final prefs = await SharedPreferences.getInstance();
    dataNotification = prefs.getStringList("notification") ?? [];
    ref.child("password").onValue.listen((event) {
      password = event.snapshot.value.toString();
      print(password);
    });
    ref.child("stateDoor").onValue.listen((event) {
      stateDoor = event.snapshot.value as bool;
    });
    ref.child("notification").onValue.listen((event) {
      String mesage = event.snapshot.value.toString();
      if (mesage != "") {
        String s = "Mở cửa thành công: ${DateTime.now().toString().split(".")[0]} bạn đã mở khoá thành công với pass $mesage";
        dataNotification.add(s);
        prefs.setStringList("notification",dataNotification);
        if(isInit){
          AwesomeNotifications().createNotification(
          content: NotificationContent(
            channelKey: 'call_channel',
            id: 1,
            title: 'Mở Cửa thành công',
            body: s,
          )
        );
        }else{
          isInit = true;
        }
        notifyListeners();
      }
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        ref.child("notification").set("");
      });
    });
    ref.child("warning").onValue.listen((event) {
      String mesage = event.snapshot.value.toString();
      if (mesage != "") {
        String s = "Cảnh báo: ${DateTime.now().toString().split(".")[0]} đang mở khóa không thành công";
        dataNotification.add(s);
        prefs.setStringList("notification",dataNotification);
        if(isInit){
          AwesomeNotifications().createNotification(
          content: NotificationContent(
            channelKey: 'call_channel',
            id: 2,
            title: 'Cảnh báo !!!!!!!!!!!!!',
            body: s,
          )
        );
        }else{
          isInit = true;
        }
        notifyListeners();
      }
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        ref.child("warning").set("");
      });
    });
    notifyListeners();
  }

  Future<int> openDoor() async {
    try {
      await ref.child("stateDoor").set(false);
      return 1;
    } catch (e) {
      return -1;
    }
  }

// Tạo otp
  Future rndOtp() async {
    _start = 60;
    codeGeneration();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (_start == 0) {
          otp = "";
          timer.cancel();
          await ref.child("tempPassword").set(otp);
          notifyListeners();
        } else {
          _start--;
          notifyListeners();
        }
      },
    );
  }

  codeGeneration() {
    int number = Random().nextInt(9999);
    int temp = 4 - number.toString().length;
    otp = "";
    if (temp > 0) {
      for (int i = 0; i < temp; i++) {
        otp = otp + "0";
      }
    }
    otp = otp + number.toString();
    notifyListeners();
  }

  Future sendOtp() async {
    rndOtp();
    try {
      await ref.child("tempPassword").set(otp);
      print(1);
    } catch (e) {
      alert("lỗi kết nối");
      otp = "";
      notifyListeners();
    }
  }

  Future cleanNotification() async{
    dataNotification.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notification", []);
    notifyListeners();

  }

  Future<bool> chagePassword(String oldPassword, String newPassword) async{
    print(password);
    if(oldPassword == password){
      await ref.child("password").set(newPassword);
      notificationOpenDoor("Đổi pass thành công");
      return true;
    }else{
      alert("sai mật khẩu");
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:iot_esp8266/common/alert.dart';
import 'package:iot_esp8266/common/chage_password_dialog.dart';
import 'package:iot_esp8266/provider/action_state.dart';
import 'package:provider/provider.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 13, right: 12),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "Action",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      int state = await context.read<ActionState>().openDoor();
                      if(state == 0){
                        alert("Cửa đang mở");
                      }else{
                        if(state == 1){
                          notificationOpenDoor("Mở cửa thành công");
                        }else{
                          alert("lỗi kết nối");
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45),
                      child: Center(child: Text("Open Door")),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (context){
                        return ChagePassWordDialog();
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45),
                      child: Center(child: Text("Chage PassWord")),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      context.read<ActionState>().sendOtp();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45),
                      child: Center(child: Text("temporary password")),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Center(child: Text(context.watch<ActionState>().otp)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

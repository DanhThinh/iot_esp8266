import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/action_state.dart';

class ChagePassWordDialog extends StatefulWidget {
  const ChagePassWordDialog({super.key});

  @override
  State<ChagePassWordDialog> createState() => _ChagePassWordDialogState();
}

class _ChagePassWordDialogState extends State<ChagePassWordDialog> {
  String passwordOld = "";
  String passwordNew = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 13, right: 12),
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextField(
                  maxLength: 4,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      hintText: " Old password"
                  ),
                  onChanged: (value) {
                    passwordOld = value;
                  },
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLength: 4,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                       hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      hintText: " New password"
                    ),
                  onChanged: (value) {
                    passwordNew = value;
                  },
                  keyboardType: TextInputType.number,
                ),
                GestureDetector(
                  onTap: (){
                    context.read<ActionState>().chagePassword(passwordOld, passwordNew).then((value){
                      if(value){
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                    child: Text(
                      "chage",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

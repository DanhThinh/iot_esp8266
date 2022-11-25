import 'package:flutter/material.dart';
import 'package:iot_esp8266/provider/action_state.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(left: 13, right: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () {
                    context.read<ActionState>().cleanNotification();
                  }, icon: Icon(Icons.delete, color: Colors.black,))
                ],
              ),
              SizedBox(
                height: 10,
                child: Divider(color: Colors.black),
              ),
              Expanded(
                  child: Selector<ActionState, List<String>>(
                shouldRebuild: (previous, next) => true,
                selector: (context, state) => state.dataNotification,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return Center(
                      child: Text("no notification"),
                    );
                  }
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      int number = value.length - index - 1;
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: 10, top: index == 0 ? 20 : 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: value[number][0] == "M"
                              ? Colors.black38
                              : Colors.red,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(value[number]),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        ));
  }
}

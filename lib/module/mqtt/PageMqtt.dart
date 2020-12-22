import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:v_flutter_practice_2020/Contacts.dart';

import 'tools/mqtt_tool.dart';

/**
 * mqtt实现界面
 */
class PageMqtt  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MqttPage();
  }
}


class MqttPage extends State<PageMqtt> {
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>_listenSubscription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              OutlineButton(
                child: Text('建立连接'),
                onPressed: (){
                  print("${Contacts.PAGE_TAG_MQTT} 建立连接");
                  //
                  MqttTool.getInstance().connect("10.155.0.135", 32149, "1885999fuehxz5f3ced1a", "", "");
                },
                textColor: Colors.red,
                borderSide: BorderSide(color: Colors.red,),
              ),
              SizedBox(width: 20,),
              OutlineButton(
                child: Text('订阅topic'),
                onPressed: (){
                  MqttTool.getInstance().subscribeMessage("subtopic");
                },
                textColor: Colors.red,
                borderSide: BorderSide(color: Colors.red,),
              ),
              SizedBox(width: 20,),
              OutlineButton(
                child: Text('开始监听消息'),
                onPressed: (){
                  _startListen();
                },
                textColor: Colors.red,
                borderSide: BorderSide(color: Colors.red,),
              ),
              SizedBox(width: 20,),
              OutlineButton(
                child: Text('断开连接'),
                onPressed: (){
                  MqttTool.getInstance().disconnect();
                },
                textColor: Colors.red,
                borderSide: BorderSide(color: Colors.red,),
              ),
            ],
          ),
        ],
      )
    );
  }

  //  监听消息的具体实现
  _onData(List<MqttReceivedMessage<MqttMessage>> data) {
    final MqttPublishMessage recMess = data[0].payload;
    final String topic = data[0].topic;
    final String pt = Utf8Decoder().convert(recMess.payload.message);
    String desString = "topic is <$topic>, payload is <-- $pt -->";
    print("string =$desString");
    Map p = Map();
    p["topic"] = topic;
    p["type"] = "string";
    p["payload"] = pt;
    print(pt.toString());
  }

//  开启监听消息
  _startListen() {
    _listenSubscription = MqttTool.getInstance().updates().listen(_onData);
  }
}
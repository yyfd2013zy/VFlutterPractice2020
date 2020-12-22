import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
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
                  _connect();
                },
                textColor: Colors.red,
                borderSide: BorderSide(color: Colors.red,),
              ),
              SizedBox(width: 20,),
              OutlineButton(
                child: Text('订阅topic'),
                onPressed: (){

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
}
//  建立连接
/*_connect() async {
  String server = "10.155.2.4";
  int port = 31063;
  String clientId = "86-1885999fuehxz5f3ced1e";
  String userName = "";
  String password = "";
  MqttTool.getInstance()
      .connect(server, port, clientId, userName, password)
      .then((v) {
    if (v.returnCode == MqttConnectReturnCode.connectionAccepted) {
      print("${Contacts.PAGE_TAG_MQTT}恭喜你~ ====mqtt连接成功");
    } else if (v.returnCode == MqttConnectReturnCode.badUsernameOrPassword) {
      print("${Contacts.PAGE_TAG_MQTT}有事做了~ ====mqtt连接失败 --密码错误!!!");
    } else {
      print("${Contacts.PAGE_TAG_MQTT}有事做了~ ====mqtt连接失败!!!");
    }
  });
}*/

Future<MqttServerClient> _connect() async {
  MqttServerClient client =
  MqttServerClient.withPort('10.155.2.4', 'flutter_client', 31063);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMessage;
  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final payload =
    MqttPublishPayload.bytesToStringAsString(message.payload.message);

    print('Received message:$payload from topic: ${c[0].topic}>');
  });

  return client;
}

// 连接成功
void onConnected() {
  print("${Contacts.PAGE_TAG_MQTT}连接成功");
}

// 连接断开
void onDisconnected() {
  print("${Contacts.PAGE_TAG_MQTT}连接失败");
}

// 订阅主题成功
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// 订阅主题失败
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// 成功取消订阅
void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}

// 收到 PING 响应
void pong() {
  print('Ping response client callback invoked');
}
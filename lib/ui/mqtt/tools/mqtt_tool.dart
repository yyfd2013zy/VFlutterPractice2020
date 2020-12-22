import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../Contacts.dart';

typedef ConnectedCallback = void Function();

class MqttTool {
  MqttQos qos = MqttQos.atLeastOnce;
  MqttClient mqttClient;
  static MqttTool _instance;

  static MqttTool getInstance() {
    if (_instance == null) {
      _instance = MqttTool();
    }
    return _instance;
  }

  Future<MqttClientConnectionStatus> connect(String server, int port,
      String clientIdentifier, String username, String password,
      {bool isSsl = false}) {
    mqttClient = MqttClient.withPort(server, clientIdentifier, port);

    mqttClient.onConnected = onConnected;

    mqttClient.onSubscribed = _onSubscribed;

    mqttClient.onSubscribeFail = _onSubscribeFail;

    mqttClient.onUnsubscribed = _onUnSubscribed;

    mqttClient.setProtocolV311();
    mqttClient.logging(on: false);
    if (isSsl) {
      mqttClient.secure = true;
      mqttClient.onBadCertificate = (dynamic a) => true;
    }
    print("${Contacts.PAGE_TAG_MQTT}连接中");
    return mqttClient.connect(username, password);
  }

  disconnect() {
    showLogInfo("断开连接");
    mqttClient.disconnect();
  }

  /**
   * 发送
   */
  int publishMessage(String pTopic, String msg) {
   /* _log("_发送数据-topic:$pTopic,playLoad:$msg");
    Uint8Buffer uint8buffer = Uint8Buffer();
    var codeUnits = msg.codeUnits;
    uint8buffer.addAll(codeUnits);

    return mqttClient.publishMessage(pTopic, qos, uint8buffer, retain: false);*/
  }

  /**
   * 发送
   */
  int publishRawMessage(String pTopic, List<int> list) {
/*  _log("_发送数据-topic:$pTopic,playLoad:$list");
    Uint8Buffer uint8buffer = Uint8Buffer();
//    var codeUnits = msg.codeUnits;
    uint8buffer.addAll(list);
    return mqttClient.publishMessage(pTopic, qos, uint8buffer, retain: false);*/
  }

  Subscription subscribeMessage(String subtopic) {
    showLogInfo("订阅消息！");
    return mqttClient.subscribe(subtopic, qos);
  }

  unsubscribeMessage(String unSubtopic) {
    showLogInfo("取消订阅！");
    mqttClient.unsubscribe(unSubtopic);
  }

  MqttClientConnectionStatus getMqttStatus() {
    return mqttClient.connectionStatus;
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> updates() {
    print("${Contacts.PAGE_TAG_MQTT} updates messages 开始监听消息");
    return mqttClient.updates;
  }

  onConnected() {
//    mqttClient.onConnected = callback;
    showLogInfo("连接成功");
  }

  onDisConnected(ConnectedCallback callback) {
    mqttClient.onDisconnected = callback;
    print("${Contacts.PAGE_TAG_MQTT}断开连接");
  }

  _onSubscribed(String topic) {
    showLogInfo("主题订阅成功！");
  }

  _onUnSubscribed(String topic) {
    showLogInfo("取消订阅成功！");
  }

  _onSubscribeFail(String topic) {
    showLogInfo("订阅失败！");
  }


  void showLogInfo(String s) {
    print("${Contacts.PAGE_TAG_MQTT} ${s}");
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

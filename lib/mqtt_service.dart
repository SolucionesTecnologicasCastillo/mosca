import 'dart:async';


import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MqttService{


  late MqttServerClient client;

  String payload = '';

  final List<String> _topics = [];

  MqttService(String clientName){
    connect(clientName);
  }

  Future<MqttServerClient> connect(String clientName) async {
    //en server pones la ip, o url ej: google.com
    client =
        MqttServerClient.withPort('server', clientName,1883,maxConnectionAttempts: 3);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    try {
      //Pones el usuario y pass
      await client.connect('user', 'password');

    } catch (e) {

      client.disconnect();
    }
    return client;
  }


  Future<void> publish(String topic,String message) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce,builder.payload!);
  }

  StreamSubscription subscriptionResponse() {
    return client.updates!.listen((event) {
      for (var element in event) {
        final received = element.payload as MqttPublishMessage;
        payload =  MqttPublishPayload.bytesToStringAsString(received.payload.message);
        print(payload);
      }
    });
  }

  Future<void> subscribe(String topic) async {
    try{
      if(client.connectionStatus!.state==MqttConnectionState.connected) {
        client.subscribe(topic, MqttQos.atLeastOnce);
      }
    }catch(e){
      rethrow ;
    }
  }

  void unSubscribeAll() {
    try{
      if(client.connectionStatus!.state==MqttConnectionState.connected) {
        for (var topic in _topics) {
          client.unsubscribe(topic);
        }
      }
      _topics.clear();
    }catch(e){
      rethrow;
    }
  }

  void unSubscribe(String topic) {
    try{
      if(client.connectionStatus!.state==MqttConnectionState.connected) {
        client.unsubscribe(topic);
      }
      _topics.clear();
    }catch(e){
      rethrow;
    }
  }


  // connection succeeded
  void onConnected() {
    client.connectionStatus!.state = MqttConnectionState.connected;
  }

// unconnected
  void onDisconnected() {
    client.connectionStatus!.state = MqttConnectionState.disconnected;
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    _topics.add(topic);
    if (kDebugMode) {
      print('Subscribed topic: $topic');
    }
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    if (kDebugMode) {
      print('Failed to subscribe $topic');
    }
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    if (kDebugMode) {
      print('Unsubscribed topic: $topic');
    }
  }

}
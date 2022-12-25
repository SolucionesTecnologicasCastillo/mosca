import 'package:flutter/material.dart';
import 'package:mosca/mqtt_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MqttService _mqttService;

  @override
  void initState() {
    _mqttService = MqttService('Prueba');
    _mqttService.subscriptionResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba mqtt'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  _mqttService.connect('Prueba 2');
                },
                child: const Text('Connect')),
            TextButton(
                onPressed: () {
                  _mqttService.subscribe('test');
                },
                child: const Text('Subscribe')),
            TextButton(
                onPressed: () {
                  _mqttService.publish('test', 'Hola a todos');
                },
                child: const Text('Publish')),
            TextButton(
                onPressed: () {
                  _mqttService.unSubscribe('Unsuscribe');
                },
                child: const Text('Unsuscribe')),
            TextButton(
                onPressed: () {
                  _mqttService.client.disconnect();
                },
                child: const Text('Disconnect')),
            Text(_mqttService.payload)
          ],
        ),
      ),
    );
  }
}

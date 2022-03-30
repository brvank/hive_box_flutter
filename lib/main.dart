import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  var temp = await Hive.initFlutter();
  runApp(HiveApp());
}

class HiveApp extends StatefulWidget {
  const HiveApp({Key? key}) : super(key: key);

  @override
  _HiveAppState createState() => _HiveAppState();
}

class _HiveAppState extends State<HiveApp> {
  late String message;
  late TextEditingController controller;
  late Box messageBox;
  late bool loading;

  @override
  void initState() {
    super.initState();
    setUp();
  }

  Future<void> setUp() async {
    setState(() {
      loading = true;
    });
    messageBox = await Hive.openBox('message');
    messageBox = await Hive.openBox('message');
    message = await messageBox.get('message', defaultValue: '');
    controller = TextEditingController();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive app',
      home: Scaffold(
        appBar: AppBar(title: Text('Hive App')),
        body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: EdgeInsets.all(8), child: Text(message)),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: controller,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      child: Center(
                          child: InkWell(
                        child: Text('Save message'),
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          //save to the storage using hiveawait
                          messageBox.put('message', controller.text);
                          message = messageBox.get('message');
                          controller.text = '';
                          setState(() {
                            loading = false;
                          });
                        },
                      )),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

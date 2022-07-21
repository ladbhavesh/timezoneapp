import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezoneapp/timzonecontroller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Timezone converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Timezone converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _controller = Get.put(TimezoneController());
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('HH:mm');

  _MyHomePageState() {
    var now = DateTime.now();

    var date = dateFormat.format(now);
    var time = timeFormat.format(now);

    _dateController = TextEditingController(text: date);
    _timeController = TextEditingController(text: time);
  }

  bool _isValid(String from, String to, String date, String time) {
    if (from.isEmpty || to.isEmpty || date.isEmpty || time.isEmpty) {
      return false;
    }

    if (!_controller.timezones.contains(from)) {
      return false;
    }

    if (!_controller.timezones.contains(to)) {
      return false;
    }

    if (from.toLowerCase() == to.toLowerCase()) {
      return false;
    }

    if (DateTime.tryParse("$date $time") == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          print(_controller.timezones.value.length);
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                        border: OutlineInputBorder(gapPadding: 4),
                        //enabledBorder: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        hintText: "From timezone name (e.g. Asia/India)",
                        label: Text('From timezone'),
                        //border: InputBorder.,
                      ),
                      child: Autocomplete<String>(
                        onSelected: (option) {
                          _controller.selectedFromTimezone.value = option;
                        },
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return Iterable<String>.empty();
                          }

                          return _controller.timezones.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                        border: OutlineInputBorder(gapPadding: 4),
                        //enabledBorder: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        hintText: "To timezone name (e.g. Asia/India)",
                        label: Text('To timezone'),
                        //border: InputBorder.,
                      ),
                      child: Autocomplete<String>(
                        onSelected: (option) {
                          _controller.selectedToTimezone.value = option;
                        },
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return Iterable<String>.empty();
                          }

                          return _controller.timezones.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(gapPadding: 4),
                          hintText: 'Date in yyyy-mm-dd',
                          label: Text("Date")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Time in HH:MM (24h)',
                          label: Text("Time in HH:MM (24h)")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (() {
                              _controller.selectedTime.value =
                                  _timeController.value.text;
                              _controller.selectedDate.value =
                                  _dateController.value.text;

                              var isValid = _isValid(
                                  _controller.selectedFromTimezone.value,
                                  _controller.selectedToTimezone.value,
                                  _dateController.text,
                                  _timeController.text);

                              if (!isValid) {
                                _controller.errorInInput.value =
                                    "Error in inputs";
                                return;
                              }

                              _controller.convertTime();
                            }),
                            child: const Text("Calculate"))),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        //width: double.infinity,
                        //height: 50,
                        child: Obx(() {
                      if (_controller.isConversionLoading.value) {
                        return const CircularProgressIndicator();
                      }

                      if (_controller.convertedTime.isEmpty) {
                        return const Text("");
                      }

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: _controller.errorInInput.value.isEmpty
                            ? Text(_controller.convertedTime.value,
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                  //decorationColor: Colors.yellow,
                                ))
                            : Text(_controller.errorInInput.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                  //decorationColor: Colors.yellow,
                                )),
                      );
                    }))
                  ],
                ),
              ),
            ),
          );
        }),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

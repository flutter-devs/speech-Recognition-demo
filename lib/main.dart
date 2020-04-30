import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: speechButton(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Text(
              resultText,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[


              FloatingActionButton(
                child: Icon(Icons.cancel),
                mini: true,
                backgroundColor: Colors.red,
                onPressed: () {
                  if (_isListening)
                    _speechRecognition.cancel().then(
                          (result) => setState(() {
                                _isListening = result;
                                resultText = "";
                              }),
                        );
                },
              ),

              FloatingActionButton(
                child: Icon(Icons.stop),
                mini: true,
                backgroundColor: Colors.red,
                onPressed: () {
                  if (_isListening)
                    _speechRecognition.stop().then(
                          (result) => setState(() => _isListening = result),
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  speechButton() =>Container(
    height: 100,
    width: double.infinity,
    alignment: Alignment.center,
    child:   FloatingActionButton(
      child: Icon(Icons.mic),
      onPressed: () {
        if (_isAvailable && !_isListening)
          _speechRecognition
              .listen(locale: "en_IN")
              .then((result) => print('$result'));
      },
      backgroundColor: Colors.pink,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Dad Joke App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _joke = 'Click the button to get a joke';

  Future<void> fetchJoke() async {
    try {
      final response = await http.get(Uri.parse('https://icanhazdadjoke.com/'), headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        setState(() {
          _joke = json.decode(response.body)['joke'];
        });
      } else {
        setState(() {
          _joke = 'Failed to load joke';
        });
      }
    } catch (e) {
      setState(() {
        _joke = 'Failed to load joke: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _joke,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchJoke,
        tooltip: 'Get Joke',
        child: const Icon(Icons.sentiment_very_satisfied),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

	const MyApp({Key? key}) : super(key: key);
  
	@override
	Widget build(BuildContext context) => MaterialApp(
		home: MyHomePage(),
		title: 'Flutter Demo',
		theme: ThemeData.light()
	);
}

class MyHomePage extends StatelessWidget {

	const MyHomePage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Example'),
			),
			body: ListView(
				children: [
					MintImage('https://x-images4.bangbros.com/monstersofcock/shoots/mc17154/members/450x340.jpg'),
					MintVideoPlayer()
				]
			)
		);
	}
}

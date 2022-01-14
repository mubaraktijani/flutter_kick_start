import 'package:flutter/material.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

	const MyApp({Key? key}) : super(key: key);
  
	@override
	Widget build(BuildContext context) => MaterialApp(
		home: const MyHomePage(),
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
					MintVideoPlayer(),
					MintImage('https://photo.tuchong.com/4870004/f/298584322.jpg'),
					PasswordFormField(),
					SelectFormField(
						label: 'Gender',
						options: const ['male', 'female'],
						onChanged: (val) => print(val)
					)
				]
			)
		);
	}
}

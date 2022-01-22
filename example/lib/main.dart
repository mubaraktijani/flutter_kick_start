import 'package:flutter/material.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

	const MyApp({Key? key}) : super(key: key);
  
	@override
	Widget build(BuildContext context) => ScreenUtilInit(
		minTextAdapt: true,
		splitScreenMode: true,
		builder: () => MaterialApp(
			home: const MyHomePage(),
			title: 'Flutter Demo',
			theme: ThemeData.light(),
			builder: (context, widget) {
				ScreenUtil.setContext(context);
				return MediaQuery(
					data: MediaQuery.of(context).copyWith(textScaleFactor: .8),
					child: widget!
				);
			}
		)
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
					MintVideoPlayer(
						'assets/sample1/video.mp4',
						thumbnail: 'assets/sample1/thumb.jpg',
					).h(context.screenHeight * .3),
					MintImage('assets/sample1/thumb.jpg'),
					PasswordFormField(),
					SelectFormField(
						label: 'Gender',
						options: const ['male', 'female'],
						onChanged: (val) => {}
					)
				]
			)
		);
	}
}

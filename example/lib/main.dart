import 'package:example/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

void main() {
	FlutterKickStart(
		baseUrl: 'http://google.com'
	).init();
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {

	const MyApp({Key? key}) : super(key: key);
  
	@override
	Widget build(BuildContext context) {
		
		return ScreenUtilInit(
			minTextAdapt: true,
			splitScreenMode: true,
			builder: () => MaterialApp(
				home: MyHomePage(),
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
}

class MyHomePage extends StatelessWidget {

	ExampleService exampleService = ExampleService();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Example'),
			),
			body: ListView(
				children: [
					Text(exampleService.test1()),
					// MintVideoPlayer(
					// 	VideoPlayerController.asset(
					// 		'assets/sample1/video.mp4',
					// 		videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
					// 	),
					// 	// thumbnail: 'assets/sample1/thumb.jpg',
					// ).h(context.screenHeight * .3),
					// MintImage('assets/sample1/thumb.jpg'),
					// PasswordFormField(),
					// SelectFormField(
					// 	label: 'Gender',
					// 	options: const ['male', 'female'],
					// 	onChanged: (val) => {}
					// )
				]
			)
		);
	}
}

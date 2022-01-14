import 'package:flutter/material.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

part 'volumn_control.dart';
part 'controls_container.dart';

class MintVideoPlayer extends StatefulWidget {
	@override
	MintVideoPlayerState createState() => MintVideoPlayerState();
}

class MintVideoPlayerState extends State<MintVideoPlayer> {

	late VideoPlayerController _controller;

	Future<ClosedCaptionFile> _loadCaptions() async {
		final String fileContents = await DefaultAssetBundle.of(context)
			.loadString('assets/bumble_bee_captions.vtt');
		return WebVTTCaptionFile(fileContents); // For vtt files, use WebVTTCaptionFile
	}

	@override
	void initState() {
		super.initState();
		_controller = VideoPlayerController.network(
			'https://firebasestorage.googleapis.com/v0/b/kabiru-tanimu-turaki.appspot.com/o/Ebony%20PMV(high).mp4?alt=media&token=122dc8e7-7833-44b3-b5e7-65d0424d060c',
			// closedCaptionFile: _loadCaptions(),
			videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
		);
		_controller.setLooping(false);
		_controller.initialize();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return AspectRatio(
			aspectRatio: _controller.value.aspectRatio,
			child: Stack(
				alignment: Alignment.bottomCenter,
				children: <Widget>[
					VideoPlayer(_controller),
					// ClosedCaption(text: _controller.value.caption.text),
					ControlsContainer(controller: _controller)
				]
			)
		);
	}
}
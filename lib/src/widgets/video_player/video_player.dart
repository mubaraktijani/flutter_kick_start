import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

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
			'https://cdn77-vid-mp4.xvideos-cdn.com/6gnj4Xt99t8H69W0v0jVtQ==,1639896874/videos/mp4/0/3/9/xvideos.com_0392b2233d6642f858137622cd789cae.mp4',
			// closedCaptionFile: _loadCaptions(),
			videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
		);

		_controller.addListener(() {
			setState(() {});
		});
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
					ClosedCaption(text: _controller.value.caption.text),
					_ControlsOverlay(controller: _controller),
					VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
			)
		);
	}
}


class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
	@override
	Widget build(BuildContext context) {
		return Stack(
		children: <Widget>[
			AnimatedSwitcher(
				duration: Duration(milliseconds: 50),
				reverseDuration: Duration(milliseconds: 200),
				child: widget.controller.value.isPlaying
					? SizedBox.shrink()
					: Container(
						child: playButton().centered()
					)
			), 
			// GestureDetector(
			// 	onTap: () {
			// 		controller.value.isPlaying ? controller.pause() : controller.play();
			// 	}
			// ),
			Align(
			alignment: Alignment.topRight,
			child: PopupMenuButton<double>(
				initialValue: widget.controller.value.playbackSpeed,
				tooltip: 'Playback speed',
				onSelected: (speed) {
				widget.controller.setPlaybackSpeed(speed);
				},
				itemBuilder: (context) {
				return [
					for (final speed in _ControlsOverlay._examplePlaybackRates)
					PopupMenuItem(
						value: speed,
						child: Text('${speed}x'),
					)
				];
				},
				child: Padding(
				padding: const EdgeInsets.symmetric(
					// Using less vertical padding as the text is also longer
					// horizontally, so it feels like it would need more spacing
					// horizontally (matching the aspect ratio of the video).
					vertical: 12,
					horizontal: 16,
				),
				child: Text('${widget.controller.value.playbackSpeed}x'),
				),
			),
			),
		],
		);
	}

	Widget playButton() {
		double size = context.screenWidth * .1;

		return Container(
			decoration: BoxDecoration(
				color: context.primaryColor.withOpacity(.4),
				border: Border.all(width: 1, color: context.primaryColor),
				shape: BoxShape.circle
			),
			child: InkWell(
				onTap: () => widget.controller.value.isPlaying 
					? widget.controller.pause() 
					: widget.controller.play(),
				child: Icon(
					Icons.play_arrow_outlined,
					semanticLabel: 'Play',
				).iconSize(size * .7).iconColor(Colors.white).centered()
			)
		).w(size).h(size);
	}
}
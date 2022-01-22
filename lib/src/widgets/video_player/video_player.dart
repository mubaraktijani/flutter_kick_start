import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';

import 'volume_progress_bar.dart';

part 'volumn_control.dart';
part 'controls_container.dart';
part 'bottom_control_bar.dart';
part 'fullscreen_view.dart';

class MintVideoPlayer extends StatefulWidget {

	final double? height;
	final bool repeat;
	final String? thumbnail;
	final String video;
	final bool autoplay;

	MintVideoPlayer(this.video, {
		this.thumbnail, 
		this.height,
		this.repeat: false,
		this.autoplay: true
	});

	@override
	MintVideoPlayerState createState() => MintVideoPlayerState();
}

class MintVideoPlayerState extends State<MintVideoPlayer> {

	late VideoPlayerController _controller;
	late VideoPlayerValue _videoPlayerValue;
	bool isPlayed = false;
	bool isFullscreen = false;
	
	late StreamSubscription<double> _subscription;

	VideoPlayerController _getController() {
		if (Uri.parse(widget.video).isAbsolute) {
			return VideoPlayerController.network(
				widget.video,
				videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
			);
		}

		return VideoPlayerController.asset(
			widget.video,
			videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
		);
	}

	@override
	void initState() {
		super.initState();

		_controller = this._getController();
		_videoPlayerValue = _controller.value;
		_controller.addListener(() {
			if(!isFullscreen) {
				VideoPlayerValue playerValue = _controller.value;

				if(playerValue.duration == playerValue.position) {
					_controller.seekTo(Duration());
				}

				setState(() => _videoPlayerValue = playerValue);
			}
		});

		_controller.setLooping(widget.repeat);
	}

	@override
	void dispose() {
		_subscription.cancel();
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			height: double.infinity,
			width: double.infinity,
			color: Colors.black,
			child:AnimatedSwitcher(
				duration: Duration(milliseconds: 1000),
				reverseDuration: Duration(milliseconds: 600),
				child: widget.thumbnail != null && !isPlayed
					? videoThumbnailView()
					: initVideoPlayer()
			)
		);
	}

	Widget videoThumbnailView() => Stack(
		alignment: Alignment.center,
		children: [
			MintImage(
				widget.thumbnail!,
				fit: BoxFit.cover
			),
			Positioned.fill(child: this.playIcon())
			
		],
	);

	Widget initVideoPlayer() => _videoPlayerValue.isInitialized
		? videoPlayerView()
		: FutureBuilder(
			future: _controller.initialize()
				.then((value) {
					if (widget.thumbnail != null) _controller.play();
				}),
			builder: (_, snapshot) {
				if(
					!snapshot.hasError && 
					snapshot.connectionState == ConnectionState.done
				) return videoPlayerView();

				if(snapshot.hasError)
					return Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							'${snapshot.error}'.text
								.align(TextAlign.center)
								.white
								.make()
						]
					).pSymmetric(h: context.screenWidth * .2);

				return CircularProgressIndicator();
			}
		).centered();

	Widget videoPlayerView() => Stack(
		alignment: Alignment.bottomCenter,
		children: [
			AspectRatio(
				aspectRatio: _controller.value.aspectRatio,
				child: VideoPlayer(_controller)
			),
			if(!isPlayed) Positioned.fill(child: this.playIcon()),
			if(isPlayed) ControlsContainer(
				controller: _controller,
				videoPlayerValue: _videoPlayerValue
			),
		]
	);

	Widget playIcon() => Container(
	  child: GestureDetector(
	  	onTap: () {
	  		if(_videoPlayerValue.isInitialized && !_videoPlayerValue.isPlaying) {
	  			_controller.play();
	  		}
	  		
	  		setState(() => isPlayed = true );
	  	},
	  	child: Container(
			color: Colors.black.withOpacity(.1),
			child: Card(
				margin: EdgeInsets.zero,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(30),
					side: BorderSide(color: context.primaryColor)
				),
				color: context.primaryColor.withOpacity(.4),
				child: Icon(Ionicons.ios_play_outline)
					.iconSize(20)
					.iconColor(Colors.white)
					.p(12)
			).centered(),
	  	)
	  ),
	);
}
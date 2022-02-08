import 'dart:ui';
import 'package:flutter/material.dart';
export 'package:video_player/video_player.dart';
import 'package:flutter_kick_start/flutter_kick_start.dart';

import 'player.dart';
import 'play_overlay.dart';
import 'controls/index.dart';

part 'controls_container.dart';
part 'bottom_control_bar.dart';

class MintVideoPlayer extends StatefulWidget {

	final bool repeat;
	final bool autoplay;
	final double? height;
	final String? thumbnail;
	final VideoPlayerController controller;

	MintVideoPlayer(this.controller, {
		this.thumbnail, 
		this.height,
		this.repeat: false,
		this.autoplay: true
	});

	@override
	MintVideoPlayerState createState() => MintVideoPlayerState();
}

class MintVideoPlayerState extends State<MintVideoPlayer> {

	bool isPlayed = false;
	bool isFullscreen = false;
	bool isPlaying = false;
	bool isInitialized = false;
	
	@override
	void initState() {
		widget.controller.setLooping(widget.repeat);
		widget.controller.addListener(() {
			if (mounted) {
				setState(() {
					isPlaying = widget.controller.value.isPlaying;
					isInitialized = widget.controller.value.isInitialized;
				});
			}
		});		
		super.initState();
	}

	@override
	void dispose() {
		widget.controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedSwitcher(
			duration: Duration(milliseconds: 300),
			child: !isFullscreen
				? Player(
					isPlayed: this.isPlayed || isPlaying,
					thumbnail: widget.thumbnail,
					playOverlay: _playOverlay(), 
					controller: widget.controller,
					children: [
						controlView()
					]
				)
				: Container()
		)
		.h(widget.height ?? context.screenHeight * .3)
		.w(double.infinity)
		.backgroundColor(Colors.black);
	}

	Widget controlView() => ControlsContainer(
		controller: widget.controller,
		bottomControl: BottomControlBar(
			controller: widget.controller,
			onFullscreen: (_isFullscreen) => setState(
				() => isFullscreen = _isFullscreen
			)
		)
	);

	Widget _playOverlay() => PlayOverlay(
		onPlayed: (){
			if(isInitialized && !isPlaying) widget.controller.play();
			setState(() => isPlayed = true );
		}
	);
}
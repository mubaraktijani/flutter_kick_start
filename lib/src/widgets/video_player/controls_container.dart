part of 'video_player.dart';

class ControlsContainer extends StatefulWidget {
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

	const ControlsContainer({required this.controller});
	
	final VideoPlayerController controller;
  
	@override
	_ControlsContainerState createState() => _ControlsContainerState();
}

class _ControlsContainerState extends State<ControlsContainer> {

	bool showControls = false;
	bool isVideoStarted = false;
	Duration transitionDuration = Duration(milliseconds: 500);

	late Duration videoPosition;
	late Duration videoDuration;
	late VideoPlayerValue videoPlayerValue;

	toggleControlBars() {
		print('ddgdfgdyfdydftyd');
		setState(() => this.showControls = true);
		Future.delayed(
			Duration(seconds: 6),
			() => setState(() => this.showControls = false)
		);
	}

	togglePlay() async {
		if(!this.videoPlayerValue.isPlaying) {
			await widget.controller.play();
			setState((){
				this.isVideoStarted = videoPlayerValue.position.inSeconds > 0;
				this.showControls = !this.showControls;
			});
			return;
		}

		await widget.controller.pause();
	}

	@override
	Widget build(BuildContext context) {
		if (!widget.controller.value.isInitialized) {
			return SizedBox();
		}

		this.showControls = !widget.controller.value.isPlaying;
		this.isVideoStarted = widget.controller.value.isPlaying;
		this.videoPlayerValue = widget.controller.value;

		this.videoDuration = videoPlayerValue.duration;
		this.videoPosition = videoPlayerValue.position;

		return AnimatedSwitcher(
			duration: Duration(milliseconds: 50),
			child: 
			this.videoPosition.inMilliseconds < 1 || this.videoPosition == this.videoDuration
				? Container(
					color: Colors.black.withOpacity(.1),
					child: playButton().centered()
				)
				: 
				Stack(
					children: [
						if(!this.showControls)
						Positioned.fill(
							child: this.showControls
								? AnimatedOpacity(
									opacity: this.showControls ? 1 : 0,
									duration: Duration(milliseconds: 50),
									child: Container(
										height: double.infinity,
										width: double.infinity,
										child: _controls()
									)
								)
								: GestureDetector(
									onTap: () => this.toggleControlBars(),
									child: Container(color: Colors.red.withOpacity(.9),)
								)
						)
					],
				)
		);
	}
	
	Widget _controls() => Stack(
		children: [
			SizedBox.expand(),
			Positioned(
				bottom: Sizes.PADDING_10, left: 0, right: 0,
				height: kToolbarHeight,
				child: AnimatedOpacity(
					duration: Duration(milliseconds: 500),
					opacity: 1,
					child: Container(
						width: context.screenWidth * .9,
						color: Colors.black.withOpacity(.5),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								ProgressBar(
									barHeight: 4.0, 
									thumbRadius: 5.0,
									progress: widget.controller.value.position,
									buffered: widget.controller.value.buffered.first.end,
									total: widget.controller.value.duration,
									timeLabelLocation: TimeLabelLocation.sides,
									timeLabelPadding: 0,
									timeLabelType: TimeLabelType.totalTime,
									timeLabelTextStyle: context.textTheme.caption?.copyWith(
										color: Colors.white
									),
									onSeek: widget.controller.seekTo,
								).pOnly(bottom: Sizes.PADDING_4),
								Row(
									children: [
										InkWell(
											onTap: () => togglePlay(),
											child: Icon(Icons.play_arrow)
												.iconColor(Colors.white)
												.iconSize(Sizes.text28)
										)
									],
								)
							]
						).pSymmetric(h: 16)
					)
				).cornerRadius(5).centered()
			)
		]
	);

	Widget playButton() {
		double size = context.screenWidth * .1;

		return Container(
			decoration: BoxDecoration(
				color: context.primaryColor.withOpacity(.4),
				border: Border.all(width: 1, color: context.primaryColor),
				shape: BoxShape.circle
			),
			child: InkWell(
				onTap: () => togglePlay(),
				child: Icon(
					Icons.play_arrow_outlined,
					semanticLabel: 'Play',
				).iconSize(size * .7).iconColor(Colors.white).centered()
			)
		).w(size).h(size);
	}
}
						
// 							child: AnimatedOpacity(
// 								duration: Duration(milliseconds: 500),
// 								opacity: showControls ? 1 : 0,
// 					child: Container(
// 						width: context.screenWidth * .7,
// 						height: double.infinity,
// 						color: Colors.black.withOpacity(.5),
// 						child: Column(
// 							children: [
// 								ProgressBar(
// 									barHeight: 2.0, 
// 									thumbRadius: 5.0,
// 									progress: widget.controller.value.position,
// 									buffered: widget.controller.value.buffered.first.end,
// 									total: widget.controller.value.duration,
// 									timeLabelLocation: TimeLabelLocation.sides,
// 									timeLabelPadding: 0,
// 									timeLabelType: TimeLabelType.totalTime,
// 									timeLabelTextStyle: context.textTheme.caption?.copyWith(
// 										color: Colors.white
// 									),
// 									onSeek: (duration) {
// 										widget.controller.seekTo(duration);
// 									}
// 								),
// 								Row(
// 									children: [
// 										Icon(Icons.play_arrow)
// 											.iconColor(Colors.white),
// 										PopupMenuButton<double>(
// 											initialValue: widget.controller.value.playbackSpeed,
// 											iconSize: 10,
// 											icon: Icon(Icons.volume_down)
// 											.iconColor(Colors.white),
// 											tooltip: 'Playback speed',
// 											onSelected: (speed) {
// 											widget.controller.setPlaybackSpeed(speed);
// 											},
// 											itemBuilder: (context) {
// 											return [
// 												for (final speed in _ControlsOverlay._examplePlaybackRates)
// 												PopupMenuItem(
// 													value: speed,
// 													child: Text('${speed}x'),
// 												)
// 											];
// 											}
// 										)
// 									],
// 								)
// 							]
// 						)
// 					)
// 				).centered()
// 			),

// 						Visibility(
// 							visible: this.showControls,
// 							child: GestureDetector(
// 								onTap: toggleControlBars,
// 								child: SizedBox.expand(),
// 							), 
// 						),

// 					],
// 				)
// 		);

// 		Stack(
// 		children: <Widget>[
// 			if(!widget.controller.value.isPlaying)
// 			AnimatedSwitcher(
// 				duration: Duration(milliseconds: 50),
// 				child: widget.controller.value.isPlaying
// 					? SizedBox.shrink()
// 					: Container(
// 						color: Colors.black.withOpacity(.1),
// 						child: playButton().centered()
// 					)
// 			),
// 			if(widget.controller.value.isPlaying)
// 			GestureDetector(
// 				onTap: () {
// 					setState(() => this.showControls = !this.showControls);
// 					Future.delayed(
// 						Duration(seconds: 600), 
// 						() => setState(
// 							() => this.showControls = !this.showControls
// 						)
// 					);
// 				}
// 			),
// 			Positioned(
// 				bottom: 0,
// 				height: kToolbarHeight,
// 				left: 0, right: 0,
// 				child: AnimatedOpacity(
// 					duration: Duration(milliseconds: 500),
// 					opacity: showControls ? 1 : 0,
// 					child: Container(
// 						width: context.screenWidth * .7,
// 						height: double.infinity,
// 						color: Colors.black.withOpacity(.5),
// 						child: Column(
// 							children: [
// 								ProgressBar(
// 									barHeight: 2.0, 
// 									thumbRadius: 5.0,
// 									progress: widget.controller.value.position,
// 									buffered: widget.controller.value.buffered.first.end,
// 									total: widget.controller.value.duration,
// 									timeLabelLocation: TimeLabelLocation.sides,
// 									timeLabelPadding: 0,
// 									timeLabelType: TimeLabelType.totalTime,
// 									timeLabelTextStyle: context.textTheme.caption?.copyWith(
// 										color: Colors.white
// 									),
// 									onSeek: (duration) {
// 										widget.controller.seekTo(duration);
// 									}
// 								),
// 								Row(
// 									children: [
// 										Icon(Icons.play_arrow)
// 											.iconColor(Colors.white),
// 										PopupMenuButton<double>(
// 											initialValue: widget.controller.value.playbackSpeed,
// 											iconSize: 10,
// 											icon: Icon(Icons.volume_down)
// 											.iconColor(Colors.white),
// 											tooltip: 'Playback speed',
// 											onSelected: (speed) {
// 											widget.controller.setPlaybackSpeed(speed);
// 											},
// 											itemBuilder: (context) {
// 											return [
// 												for (final speed in _ControlsOverlay._examplePlaybackRates)
// 												PopupMenuItem(
// 													value: speed,
// 													child: Text('${speed}x'),
// 												)
// 											];
// 											}
// 										)
// 									],
// 								)
// 							]
// 						)
// 					)
// 				).centered()
// 			),
// 			Align(
// 			alignment: Alignment.topRight,
// 			child: PopupMenuButton<double>(
// 				initialValue: widget.controller.value.playbackSpeed,
// 				tooltip: 'Playback speed',
// 				onSelected: (speed) {
// 				widget.controller.setPlaybackSpeed(speed);
// 				},
// 				itemBuilder: (context) {
// 				return [
// 					for (final speed in _ControlsOverlay._examplePlaybackRates)
// 					PopupMenuItem(
// 						value: speed,
// 						child: Text('${speed}x'),
// 					)
// 				];
// 				},
// 				child: Padding(
// 				padding: const EdgeInsets.symmetric(
// 					// Using less vertical padding as the text is also longer
// 					// horizontally, so it feels like it would need more spacing
// 					// horizontally (matching the aspect ratio of the video).
// 					vertical: 12,
// 					horizontal: 16,
// 				),
// 				child: Text('${widget.controller.value.playbackSpeed}x'),
// 				),
// 			),
// 			),
// 		],
// 		);
// 	}

// 	String _duration(Duration duration) {
// 		String twoDigits(int n) => n.toString().padLeft(2, "0");
// 		String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
// 		String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
// 		return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
// 	}

	// Widget playButton() {
	// 	double size = context.screenWidth * .1;

	// 	return Container(
	// 		decoration: BoxDecoration(
	// 			color: context.primaryColor.withOpacity(.4),
	// 			border: Border.all(width: 1, color: context.primaryColor),
	// 			shape: BoxShape.circle
	// 		),
	// 		child: InkWell(
	// 			onTap: () => widget.controller.value.isPlaying 
	// 				? widget.controller.pause() 
	// 				: widget.controller.play(),
	// 			child: Icon(
	// 				Icons.play_arrow_outlined,
	// 				semanticLabel: 'Play',
	// 			).iconSize(size * .7).iconColor(Colors.white).centered()
	// 		)
	// 	).w(size).h(size);
	// }

//   @override
//   Widget build(BuildContext context) {
// 	return Container(
	  
// 	);
//   }
// }
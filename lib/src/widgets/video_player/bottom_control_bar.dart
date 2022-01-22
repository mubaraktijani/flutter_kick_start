part of 'video_player.dart';

class BottomControlBar extends StatefulWidget {
	final VideoPlayerValue videoPlayerValue;
	final VideoPlayerController controller;
	final bool isFullscreen;

	BottomControlBar({
		required this.controller,
		required this.videoPlayerValue,
		this.isFullscreen: false
	});
	
	@override
	_BottomControlBarState createState() => _BottomControlBarState();
}

class _BottomControlBarState extends State<BottomControlBar> {

	Duration animationDuration = Duration(milliseconds: 700);
	// final ProgressController _controller = ProgressController();

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) => ClipRRect(
		borderRadius: BorderRadius.circular(5),
		child: BackdropFilter(
			filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
			child: Container(
				color: Colors.black.withOpacity(.3),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						Row(
							children: [
								_printDuration(widget.videoPlayerValue.position)
									.text.white.make()
									.pOnly(right: Sizes.width8),
								ClipRRect(
									borderRadius: BorderRadius.circular(10),
									child: VideoProgressIndicator(
										widget.controller, 
										colors: VideoProgressColors(
											backgroundColor: Colors.grey.withOpacity(.7),
											bufferedColor: context.primaryColor.withOpacity(.4),
											playedColor: context.primaryColor
										),
										allowScrubbing: true,
										padding: EdgeInsets.zero,
									).h(3),
								).expand(),
								_printDuration(widget.videoPlayerValue.duration)
									.text.white.make()
									.pOnly(left: Sizes.width8),
							]
						).pOnly(bottom: Sizes.height8 /2),
						Row(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								playPauseButton(),
								VolumeControl(
									controller: widget.controller,
									videoPlayerValue: widget.videoPlayerValue
								),
								Expanded(child: SizedBox()),
								InkWell(
									onTap: () => openInFullScreen(),
									child: Icon(Ionicons.ios_expand_outline)
									.iconColor(Colors.white)
									.iconSize(20)
								)
							],
						)
					]
				).pSymmetric(h: 16)
			)
		)
	);

	Widget playPauseButton() => InkWell(
		onTap: widget.videoPlayerValue.isPlaying 
			? widget.controller.pause
			: widget.controller.play,
		child: AnimatedSwitcher(
			duration: animationDuration,
			child: Icon(
				widget.videoPlayerValue.isPlaying 
					? Ionicons.ios_pause_outline 
					: Ionicons.ios_play_outline
			).iconColor(Colors.white).iconSize(20)
		)
	).centered();


	String _printDuration(Duration duration) {
		String time = '';
		if(widget.videoPlayerValue.duration.inHours > 0) {
			time += '${duration.inHours.toString().padLeft(2, "0")}:';
		}

		if(widget.videoPlayerValue.duration.inMinutes > 0) {
			time += '${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:';
		}

		if(widget.videoPlayerValue.duration.inSeconds > 0) {
			time += '${duration.inSeconds.remainder(60)}';
		}
		
		return time;
	}

	void openInFullScreen() async {
		if(widget.isFullscreen) {
			context.pop();
			return;
		}

		await widget.controller.pause();
		
		SystemChrome.setEnabledSystemUIMode(
			SystemUiMode.edgeToEdge,
			overlays: [SystemUiOverlay.bottom]
		);
		SystemChrome.setEnabledSystemUIMode(
			SystemUiMode.edgeToEdge,
			overlays: []
		);
		SystemChrome.setPreferredOrientations(
			[
				DeviceOrientation.portraitUp,
				DeviceOrientation.portraitDown,
				DeviceOrientation.landscapeLeft,
				DeviceOrientation.landscapeRight,
			],
		);

		Navigator.of(context).push(
			PageRouteBuilder(
				opaque: false,
				settings: RouteSettings(),
				pageBuilder: (c, a, s) => FullscreenView(
					controller: widget.controller
				)
			)
		)
		.then((value) {
			SystemChrome.setEnabledSystemUIMode(
				SystemUiMode.edgeToEdge,
				overlays: [SystemUiOverlay.top]
			);
			SystemChrome.setPreferredOrientations(
				[
					DeviceOrientation.portraitUp,
					DeviceOrientation.portraitDown,
				],
			);
		});
	}
}
part of 'video_player.dart';

class BottomControlBar extends StatefulWidget {
	final VideoPlayerValue videoPlayerValue;
	final VideoPlayerController controller;

	BottomControlBar({
		required this.controller,
		required this.videoPlayerValue
	});
	
	@override
	_BottomControlBarState createState() => _BottomControlBarState();
}

class _BottomControlBarState extends State<BottomControlBar> {

	Duration animationDuration = Duration(milliseconds: 700);

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
						ProgressBar(
							barHeight: 3.0, 
							thumbRadius: 4.0,
							progress: widget.videoPlayerValue.position,
							// buffered: widget.videoPlayerValue.buffered.first.end,
							total: widget.videoPlayerValue.duration,
							timeLabelLocation: TimeLabelLocation.sides,
							timeLabelPadding: 0,
							timeLabelType: TimeLabelType.totalTime,
							timeLabelTextStyle: context.textTheme.caption?.copyWith(
								color: Colors.white,
								fontWeight: FontWeight.w500
							),
							onSeek: widget.controller.seekTo,
						).pOnly(bottom: 4),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								VolumeControl(
									controller: widget.controller,
									videoPlayerValue: widget.videoPlayerValue
								),
								playPauseButton(),
								InkWell(
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
}
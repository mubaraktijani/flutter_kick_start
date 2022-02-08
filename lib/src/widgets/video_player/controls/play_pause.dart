part of 'index.dart';

enum PlayPauseState {
	played,
	paused,
	restart
}

class PlayPauseControl extends StatefulWidget {
	final Color? iconColor;
	final double? iconSize;
	final VideoPlayerController controller;
	
	PlayPauseControl({
		this.iconSize,
		this.iconColor,
		required this.controller
	});

	@override
	_PlayPauseControlState createState() => _PlayPauseControlState();
}

class _PlayPauseControlState extends State<PlayPauseControl> {

	Map<PlayPauseState, IconData> icons = {
		PlayPauseState.played: Ionicons.ios_pause_outline,
		PlayPauseState.paused: Ionicons.ios_play_outline,
		PlayPauseState.restart: Ionicons.ios_reload_outline
	};

	PlayPauseState state = PlayPauseState.played;

	@override
	void initState() {
		widget.controller.addListener(() {
			if (mounted) {
				setState((){
					state = widget.controller.value.isPlaying
						? PlayPauseState.played
						: PlayPauseState.paused;
				});
			}

			bool isPositionEven = widget.controller.value.position
				.compareTo(widget.controller.value.duration)
				.isEven;

			if(isPositionEven && mounted) {
				setState(() => state = PlayPauseState.restart);
			}
		});
		super.initState();
	}

	@override
	Widget build(BuildContext context) => InkWell(
		onTap: () {
			switch (state) {
				case PlayPauseState.paused:
					widget.controller.play();
					break;
				case PlayPauseState.played:
					widget.controller.pause();
					break;
				default: {
					widget.controller.seekTo(Duration());
					widget.controller.play();
				}
			}
		},
		child: Icon(icons[state])
			.iconSize(widget.iconSize ?? 18)
			.iconColor(widget.iconColor ?? Colors.white)
	);
}
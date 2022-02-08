part of 'index.dart';


class VolumeControl extends StatefulWidget {
	final Color? iconColor;
	final double? iconSize;
	final VideoPlayerController controller;
	
	VolumeControl({
		this.iconSize,
		this.iconColor,
		required this.controller
	});

	@override
	_VolumeControlState createState() => _VolumeControlState();
}

enum VolumeState {
	low,
	high,
	muted,
	medium
}

class _VolumeControlState extends State<VolumeControl> {

	Map<VolumeState, IconData> icons = {
		VolumeState.low: Ionicons.ios_volume_low_outline,
		VolumeState.high: Ionicons.ios_volume_high_outline,
		VolumeState.muted: Ionicons.ios_volume_mute_outline,
		VolumeState.medium: Ionicons.ios_volume_medium_outline
	};

	bool showVolumeBar = false;
	double volumeLevel = 1;
	VolumeState state = VolumeState.high;

	@override
	void initState() {
		widget.controller.addListener(() {
			VolumeState _state = state;
			double _volumeLevel = widget.controller.value.volume;

			if(_volumeLevel <= 0.2) _state = VolumeState.muted;
			if(_volumeLevel <= 0.3) _state = VolumeState.low;
			if(_volumeLevel <= 0.6) _state = VolumeState.medium;
			if(_volumeLevel > 8) _state = VolumeState.high;

			if (mounted) {
				setState(() {
					state = _state;
					volumeLevel = _volumeLevel;
				});
			}
		});
		super.initState();
	}

	@override
	Widget build(BuildContext context) => AnimatedContainer(
		duration: Duration(milliseconds: 200),
		decoration: BoxDecoration(
			color: showVolumeBar 
				? Colors.black.withOpacity(.5) 
				: Colors.transparent,
			borderRadius: BorderRadius.circular(30)
		),
		child: Row(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				InkWell(
					onTap: () => setState(
						() => showVolumeBar = !showVolumeBar
					),
					child: Icon(icons[state])
						.iconSize(widget.iconSize ?? 18)
						.iconColor(widget.iconColor ?? Colors.white)
				).pOnly(right: 4),
				AnimatedContainer(
					duration: Duration(milliseconds: 400),
					width: showVolumeBar ? 70 : 0,
					child: VideoProgressIndicator2(
						length: 1,
						position: volumeLevel,
						seekTo: widget.controller.setVolume
					)
				)
			]
		).pSymmetric(v: 5, h: 10)
	);
}
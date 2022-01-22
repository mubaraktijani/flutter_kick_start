part of 'video_player.dart';

class VolumeControl extends StatefulWidget {

	final VideoPlayerValue videoPlayerValue;
	final VideoPlayerController controller;

	VolumeControl({
		required this.controller,
		required this.videoPlayerValue
	});

	@override
	_VolumeControlState createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {

	bool isMute = false;
	bool showVolumeBar = false;

	double initial = 0;
	double percentage = 0;

	IconData volumeIcon() {
		if(widget.videoPlayerValue.volume <= 0) return Ionicons.ios_volume_mute_outline;
		if(widget.videoPlayerValue.volume <= 0.3) return Ionicons.ios_volume_low_outline;
		if(widget.videoPlayerValue.volume <= 0.5) return Ionicons.ios_volume_medium_outline;
		return Ionicons.ios_volume_high_outline;
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedContainer(
			duration: Duration(milliseconds: 200),
			decoration: BoxDecoration(
				color: showVolumeBar ? Colors.black.withOpacity(.5) : Colors.transparent,
				borderRadius: BorderRadius.circular(30)
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					InkWell(
						onTap: () {
							setState(() => showVolumeBar = !showVolumeBar);
						},
						child: Icon(volumeIcon())
							.iconSize(18)
							.iconColor(Colors.white)
					).pOnly(right: 4),
					AnimatedContainer(
						duration: Duration(milliseconds: 400),
						width: showVolumeBar ? 70 : 0,
						child: VideoProgressIndicator2(
							length: 1,
							position: widget.videoPlayerValue.volume,
							seekTo: (double position) {
								widget.controller.setVolume(position);
							},
						),
					)
				]
			).pSymmetric(v: 5, h: 10)
		);
	}
}
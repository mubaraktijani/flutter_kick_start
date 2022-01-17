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
	late StreamSubscription<double> _subscription;

	@override
	void initState() {
		super.initState();
		PerfectVolumeControl.getVolume().then((volume){
			widget.controller.setVolume(volume);
			setState(() => percentage = (volume * 100));
		});

		PerfectVolumeControl.hideUI = true;
		_subscription = PerfectVolumeControl.stream.listen((volume) {
			widget.controller.setVolume(volume);
			setState(() => percentage = (volume * 100));
		});
	}

	@override
	void dispose() {
		_subscription.cancel();
		super.dispose();
	}

	IconData volumeIcon() {
		if(widget.videoPlayerValue.volume < 1) return Ionicons.ios_volume_off_outline;
		if(widget.videoPlayerValue.volume <= 30) return Ionicons.ios_volume_low_outline;
		if(widget.videoPlayerValue.volume <= 50) return Ionicons.ios_volume_medium_outline;
		return Ionicons.ios_volume_high_outline;
	}

	@override
	Widget build(BuildContext context) {
		return Stack(
			clipBehavior: Clip.none,
			children: [
				InkWell(
					onTap: () {
						setState(() => showVolumeBar = !showVolumeBar);
					},
					child: Icon(volumeIcon())
						.iconSize(20)
						.iconColor(Colors.white)
				),
				AnimatedPositioned(
					duration: Duration(milliseconds: 300),
					top: 0, bottom: 0,
					right: showVolumeBar ? -75 : 0,
					width: showVolumeBar ? 70 : 0,
					child: Align(
						alignment: Alignment.centerLeft,
						child: volumeBar()
					)
				)
			],
		);
	}

	Widget volumeBar() => GestureDetector(
		onPanStart: (DragStartDetails details) {
			initial = details.globalPosition.dx;
		},
		onPanUpdate: (DragUpdateDetails details) {
			double distance = details.globalPosition.dx - initial;
			double percentageAdition = (percentage + (distance / 300))
				.clamp(0.0, 100.0);

			setState(() => percentage = percentageAdition);

			widget.controller.setVolume((percentageAdition/100));
		},
		onPanEnd: (DragEndDetails details) => initial = 0.0,
		child: Container(
			color: Colors.white.withOpacity(.3),
			height: 4,
			alignment: Alignment.centerLeft,
			child: FractionallySizedBox(
				child: Container(color: context.primaryColor),
				widthFactor: widget.videoPlayerValue.volume,
				heightFactor: 1
			)
		)
	);
}
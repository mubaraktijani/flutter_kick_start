part of 'video_player.dart';

class ControlsContainer extends StatefulWidget {
	final VideoPlayerValue videoPlayerValue;
	final VideoPlayerController controller;

	const ControlsContainer({
		required this.controller,
		required this.videoPlayerValue
	});
  
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

	@override
	void initState() {
		super.initState();
		widget.controller.addListener(() {
			setState(() => videoPlayerValue = widget.controller.value);
		});
	}

	toggleControlBars() {
		setState(() => this.showControls = !this.showControls);
		Future.delayed(
			Duration(seconds: 10),
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
		return Stack(
			children: [
				InkWell(
					onTap: () => this.toggleControlBars(),
					child: SizedBox.expand()
				),
				AnimatedPositioned(
					left: context.screenWidth * .05,
					right: context.screenWidth * .05, 
					child: BottomControlBar(
						controller: widget.controller,
						videoPlayerValue: widget.videoPlayerValue
					),
					height: kToolbarHeight,
					curve: Curves.bounceInOut,
					bottom: showControls 
						? 10
						: -(kToolbarHeight),
					duration: Duration(milliseconds: 500)
				)
			],
		);
	}
}
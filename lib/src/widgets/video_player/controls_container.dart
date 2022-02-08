part of 'video_player.dart';

class ControlsContainer extends StatefulWidget {
	
	final Widget bottomControl;
	final VideoPlayerController controller;

	const ControlsContainer({
		required this.controller,
		required this.bottomControl
	});
  
	@override
	_ControlsContainerState createState() => _ControlsContainerState();
}

class _ControlsContainerState extends State<ControlsContainer> {

	bool showControls = false;

	@override
	Widget build(BuildContext context) {
		return Stack(
			fit: StackFit.expand,
			children: [
				_overlay(),
				_bottomFrameControl()
			],
		);
	}

	Widget _overlay() => GestureDetector(
		onTap: () {
			setState(() => this.showControls = !this.showControls);
			Future.delayed(
				Duration(seconds: 10),
				() => setState(() => this.showControls = false)
			);
		},
		child: Container(color: Colors.transparent)
	);

	Widget _bottomFrameControl() => AnimatedPositioned(
		left: context.screenWidth * .05,
		right: context.screenWidth * .05, 
		child: _bottomControlFrame(),
		curve: Curves.bounceInOut,
		height: kToolbarHeight,
		bottom: showControls ? 10 : -(kToolbarHeight),
		duration: Duration(milliseconds: 500)
	);

	Widget _bottomControlFrame() => ClipRRect(
		borderRadius: BorderRadius.circular(5),
		child: BackdropFilter(
			filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
			child: Container(
				color: Colors.black.withOpacity(.3),
				child: widget.bottomControl.pSymmetric(h: 16)
			)
		)
	);
}
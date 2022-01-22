part of 'video_player.dart';

class FullscreenView extends StatefulWidget {
	final VideoPlayerController controller;

	FullscreenView({
		required this.controller
	});

	@override
	_FullscreenViewState createState() => _FullscreenViewState();
}

class _FullscreenViewState extends State<FullscreenView> {
	late VideoPlayerValue videoPlayerValue;

	@override
	void initState() {
		super.initState();
		widget.controller.removeListener(() { });
		widget.controller.addListener(() {
			setState(() => this.videoPlayerValue = widget.controller.value);
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.black,
			body: Dismissible(
				key: const Key('key'),
				direction: DismissDirection.vertical,
				onDismissed: (_) => Navigator.of(context).pop(),
				child: OrientationBuilder(
					builder: (context, orientation) {
						bool isPortrait = orientation == Orientation.portrait;
						return Center(
							child: Stack(
								fit: isPortrait ? StackFit.loose : StackFit.expand,
								children: [
									AspectRatio(
										aspectRatio: widget.controller.value.aspectRatio,
										child: VideoPlayer(widget.controller),
									).centered(),
									ControlsContainer(
										controller: widget.controller,
										videoPlayerValue: videoPlayerValue,
										isFullscreen: true
									)
								]
							)
						);
					}
				)
			)
		);
	}
}
import 'package:flutter/material.dart';

class VideoProgressIndicator2 extends StatefulWidget {

	final Color? backgroundColor;
	final Color? playedColor;
	final double position;
	final double length;


	final Function()? seekEnd;
	final Function()? seekStart;
	final Function(double) seekTo;

	VideoProgressIndicator2({
		this.backgroundColor,
		this.playedColor,
		this.position: 0,
		this.length: 1,
		this.seekEnd,
		this.seekStart,
		required this.seekTo
	});

	@override
	_VideoProgressIndicator2State createState() => _VideoProgressIndicator2State();
}

class _VideoProgressIndicator2State extends State<VideoProgressIndicator2> {

	double currentPosition = 0;

	@override
	void initState() {
		super.initState();
		currentPosition = widget.position;
	}

	@override
	Widget build(BuildContext context) {

		return _VideoScrubber(
			seekTo: (point) {
				setState(() => currentPosition = point);
				widget.seekTo(point);
			},
			seekEnd: () {},
			length: widget.length,
			position: widget.position,
			seekStart: () {},
			child: ClipRRect(
				borderRadius: BorderRadius.circular(4),
				child: LinearProgressIndicator(
					value: currentPosition / widget.length,
					color: widget.playedColor,
					minHeight: 4,
					backgroundColor: widget.backgroundColor ?? Colors.grey.withOpacity(.6),
				)
			)
		);
	}
}


class _VideoScrubber extends StatefulWidget {

	_VideoScrubber({
		required this.child,
		required this.length,
		required this.seekTo,
		required this.seekEnd,
		required this.position,
		required this.seekStart
	});

	final Widget child;
	final double length;
	final double position;
	final Function() seekEnd;
	final Function() seekStart;
	final Function(double) seekTo;

	@override
	_VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {

	@override
	Widget build(BuildContext context) {
		void seekToRelativePosition(Offset globalPosition) {
			final RenderBox box = context.findRenderObject() as RenderBox;
			final Offset tapPos = box.globalToLocal(globalPosition);
			final double relative = tapPos.dx / box.size.width;
			final double position = (widget.length * relative)
				.clamp(0.0, widget.length);
			widget.seekTo(position);
		}

		return GestureDetector(
			child: widget.child,
			behavior: HitTestBehavior.opaque,
			onHorizontalDragStart: (DragStartDetails details) {
				// if (!controller.value.isInitialized) {
				//   return;
				// }
				// _controllerWasPlaying = controller.value.isPlaying;
				// if (_controllerWasPlaying) {
				//   controller.pause();
				// }
				widget.seekStart();
			},
			onHorizontalDragUpdate: (DragUpdateDetails details) {
				// if (!controller.value.isInitialized) {
				//   return;
				// }
				seekToRelativePosition(details.globalPosition);
			},
			onHorizontalDragEnd: (DragEndDetails details) {
				// if (_controllerWasPlaying &&
				//     controller.value.position != controller.value.duration) {
				//   controller.play();
				// }
				widget.seekEnd();
			},
			onTapDown: (TapDownDetails details) {
				// if (!controller.value.isInitialized) {
				//   return;
				// }
				seekToRelativePosition(details.globalPosition);
			},
		);
	}
}
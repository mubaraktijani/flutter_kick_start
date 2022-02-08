part of 'index.dart';

class ProgressBar extends StatelessWidget {

	final VideoPlayerController controller;
	final Color? textColor;

	ProgressBar({required this.controller, this.textColor});

	@override
	Widget build(BuildContext context) => this.controller.value.isInitialized
		? Row(
			children: [
				ClipRRect(
					borderRadius: BorderRadius.circular(10),
					child: VideoProgressIndicator(
						this.controller, 
						colors: VideoProgressColors(
							backgroundColor: Colors.grey.withOpacity(.7),
							bufferedColor: context.primaryColor.withOpacity(.4),
							playedColor: context.primaryColor
						),
						allowScrubbing: true,
						padding: EdgeInsets.zero,
					).h(3),
				).expand(),
				timer().pOnly(left: Sizes.width4)
				// 	.pOnly(right: Sizes.width8),
				// _printDuration(this.videoPlayerValue.duration)
				// 	.text.white.make()
				// 	.pOnly(left: Sizes.width8),
			]
		)
		: SizedBox();

	Widget timer() {
		Widget position = StreamBuilder<Duration?>(
			stream: this.controller.position.asStream(),
			builder: (_, snapshot) {
				Duration duration = this.controller.value.position;

				if(snapshot.connectionState == ConnectionState.done) {
					duration = snapshot.data!;
				}

				return _parseDuration(duration: duration).text
					.color(textColor ?? Colors.white)
					.make();
			}
		);

		Widget total = ' / ${_parseDuration()}'.text
			.color(textColor ?? Colors.white)
			.make();

		return Row(children: [ position, total ]);
	}

	String _parseDuration({Duration? duration}) {
		String time = '';
		Duration total = this.controller.value.duration;
		Duration _duration = duration ?? total;

		if(total.inHours > 0) {
			time += '${_duration.inHours.toString().padLeft(2, "0")}:';
		}

		if(total.inMinutes > 0) {
			time += '${_duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:';
		}

		if(total.inSeconds > 0) {
			time += '${_duration.inSeconds.remainder(60)}';
		}
		
		return time;
	}
}
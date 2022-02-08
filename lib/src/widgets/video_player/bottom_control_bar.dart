part of 'video_player.dart';

class BottomControlBar extends StatelessWidget {
	final bool isFullscreen;
	final Function(bool)? onFullscreen;
	final VideoPlayerController controller;

	BottomControlBar({
		this.isFullscreen: false,
		this.onFullscreen,
		required this.controller
	});

	@override
	Widget build(BuildContext context) => Column(
		mainAxisAlignment: MainAxisAlignment.center,
		crossAxisAlignment: CrossAxisAlignment.center,
		children: [
			ProgressBar(controller: this.controller)
				.pOnly(bottom: Sizes.height8 /2),
			Row(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					PlayPauseControl(
						controller: this.controller
					),
					VolumeControl(
						controller: this.controller
					),
					Expanded(child: SizedBox()),
					Fullscreen.icon(
						onTap: () => onFullscreenTap(context), 
						isFullscreen: this.isFullscreen
					)
				]
			)
		]
	);

	void onFullscreenTap(BuildContext context) {
		if(isFullscreen) {
			context.pop();
		} else {
			if(this.onFullscreen != null)
				onFullscreen!(true);

			Fullscreen(
				context: context, 
				controller: controller
			).open().then((value) {
				if(this.onFullscreen != null)
					onFullscreen!(false);
			});
		}
	}
}
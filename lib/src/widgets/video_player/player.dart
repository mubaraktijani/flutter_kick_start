import 'package:flutter/material.dart';
import '../../../flutter_kick_start.dart';

class Player extends StatelessWidget {
	
	final bool isPlayed;
	final String? thumbnail;
	final Widget? playOverlay;
	final List<Widget>? children;
	final VideoPlayerController controller;

	const Player({
		this.isPlayed: false,
		this.thumbnail,
		this.children,
		this.playOverlay,
		required this.controller
	});

	@override
	Widget build(BuildContext context) => AnimatedSwitcher(
		duration: Duration(milliseconds: 300),
		reverseDuration: Duration(milliseconds: 600),
		child: this.thumbnail != null && !isPlayed
			? videoThumbnailView()
			: initVideoPlayer(context)
	);

	Widget videoThumbnailView() => Stack(
		alignment: Alignment.center,
		children: [
			MintImage(
				this.thumbnail!,
				fit: BoxFit.cover
			),
			if(this.playOverlay != null) 
				Positioned.fill( child: this.playOverlay!)
		]
	);

	Widget initVideoPlayer(BuildContext context) {
		if(this.controller.value.isInitialized) {
			return videoPlayerView(context);
		}

		return FutureBuilder(
			future: this.controller.initialize().then((value) {
				if (this.thumbnail != null) this.controller.play();
			}),
			builder: (_, snapshot) {
				if(snapshot.hasError)
					return errorView(snapshot.error.toString())
						.wHalf(context);

				if(snapshot.connectionState == ConnectionState.done) 
					return videoPlayerView(context);

				return CircularProgressIndicator();
			}
		).centered();
	}
	
	Widget videoPlayerView(BuildContext context) => Stack(
		alignment: Alignment.bottomCenter,
		children: [
			AspectRatio(
				aspectRatio: this.controller.value.aspectRatio,
				child: VideoPlayer(this.controller)
			).centered(),
			if(!isPlayed && this.playOverlay != null) 
				this.playOverlay!,

			if(isPlayed) 
				for (var child in (this.children ?? []))
				Positioned.fill(
					child: child
				) 
		]
	).hFull(context);

	Widget errorView(String error) => Column(
		mainAxisAlignment: MainAxisAlignment.center,
		crossAxisAlignment: CrossAxisAlignment.center,
		children: [
			'$error'.text
				.align(TextAlign.center)
				.white
				.make()
		]
	);
}
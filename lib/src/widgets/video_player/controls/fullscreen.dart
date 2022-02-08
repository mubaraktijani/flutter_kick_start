part of 'index.dart';

class Fullscreen {

	final BuildContext context;
	final VideoPlayerController controller;
	
	Fullscreen({
		required this.context,
		required this.controller
	});

	static Widget icon({required Function() onTap, bool isFullscreen = false}) {
		IconData iconData = !isFullscreen 
			? Ionicons.ios_expand_outline 
			: Ionicons.ios_contract_outline;
			
		return InkWell(
			onTap: onTap,
			child: Icon(iconData)
				.iconSize(18)
				.iconColor(Colors.white)
		);
	}

	view() => Scaffold(
		backgroundColor: Colors.black,
		body: OrientationBuilder(
			builder: (context, orientation) {
				return Player(
					isPlayed: true,
					controller: this.controller,
					children: [
						ControlsContainer(
							controller: this.controller,
							bottomControl: BottomControlBar(
								isFullscreen: true,
								controller: this.controller
							)
						)
					]
				).centered();
			}
		)
	);

	Future<void> open() async {
		SystemChrome.setEnabledSystemUIMode(
			SystemUiMode.edgeToEdge,
			overlays: [SystemUiOverlay.bottom]
		);
		SystemChrome.setPreferredOrientations(
			[
				DeviceOrientation.portraitUp,
				DeviceOrientation.portraitDown,
				DeviceOrientation.landscapeLeft,
				DeviceOrientation.landscapeRight,
			],
		);

		return showGeneralDialog(
			context: context,
			barrierDismissible: false,
			transitionDuration: Duration(milliseconds: 300),
			transitionBuilder: (context, animation, secondaryAnimation, child) {
				return FadeTransition(
					opacity: animation,
					child: ScaleTransition(
						scale: animation,
						child: child,
					)
				);
			},
			pageBuilder: (_, a, s) => view()
		).then((value) {
			SystemChrome.setEnabledSystemUIMode(
				SystemUiMode.edgeToEdge,
				overlays: [SystemUiOverlay.top]
			);
			SystemChrome.setPreferredOrientations(
				[
					DeviceOrientation.portraitUp,
					DeviceOrientation.portraitDown,
				],
			);
		});
	}
}
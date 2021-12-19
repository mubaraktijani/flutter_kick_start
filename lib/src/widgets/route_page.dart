import 'package:flutter/material.dart';

class RoutePage extends Page {
	
	final String pageName;
	final Widget child;
	final bool maintainState;
	final bool fullscreenDialog;
	final Widget Function(Animation<double> animation, Widget child)? transition;

	RoutePage({
		required this.pageName,
		required this.child,
		this.maintainState = true,
		this.fullscreenDialog = false,
		this.transition
	}) : super(key: ValueKey(pageName));

	@override
	Route createRoute(BuildContext context) {
		return PageRouteBuilder(
			transitionDuration: Duration(seconds: 1),
			settings: this,
			maintainState: maintainState,
			fullscreenDialog: fullscreenDialog,
			pageBuilder: (context, animation, secondaryAnimation) => child,
			transitionsBuilder: (context, animation, secondaryAnimation, child) {
				return FadeTransition(
					opacity: Tween(begin: 0.0, end: 1.0).animate(
						CurvedAnimation(
							parent: animation,
							curve: Curves.easeInOut
						)
					),
					child: child,
				);
			}
		);
	}
}

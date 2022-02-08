import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class PlayOverlay extends StatelessWidget {

	final Function() onPlayed;

	const PlayOverlay({required this.onPlayed});

	@override
	Widget build(BuildContext context) => Container(
		child: GestureDetector(
			onTap: onPlayed,
			child: Container(
				color: Colors.black.withOpacity(.1),
				child: Card(
					margin: EdgeInsets.zero,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(30),
						side: BorderSide(color: context.primaryColor)
					),
					color: context.primaryColor.withOpacity(.4),
					child: Icon(Ionicons.ios_play_outline)
						.iconSize(20)
						.iconColor(Colors.white)
						.p(12)
				).centered()
			)
		)
	);
}
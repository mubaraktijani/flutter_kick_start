library flutter_mint;

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class PasswordFormField extends StatefulWidget {

	final String? hint;
	final String? label;
	final double iconSize;
	final InputDecoration? decoration;
	final Widget? prefix;
	final Function(String?)? onSaved;
	final TextEditingController? textController;
	final String? Function(String?)? validator;

	PasswordFormField({
		this.decoration, this.hint, this.validator, this.prefix,
		this.onSaved, this.textController, this.iconSize: 13, this.label
	});

	@override
	_PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
	bool _obscureText = true;

	@override
	Widget build(BuildContext context) => TextFormField(
		obscureText: _obscureText,
		onSaved: widget.onSaved,
		controller: widget.textController,
		validator: widget.validator,
		keyboardType: TextInputType.visiblePassword,
		decoration: (widget.decoration ?? InputDecoration()).copyWith(
			prefix: widget.prefix,
			hintText: widget.hint,
			suffixIcon: IconButton(
				icon: Icon(
					_obscureText
						? Ionicons.eye_off_outline
						: Ionicons.eye_outline
				).iconSize(widget.iconSize),
				onPressed: () => setState(() => _obscureText = !_obscureText)
			)
		)
	);
}
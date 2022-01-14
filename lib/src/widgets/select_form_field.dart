
import 'package:flutter/material.dart';

class SelectFormField<T> extends StatefulWidget {
	final String? hint;
	final String? label;
	final List<T> options;
	final InputDecoration? decoration;
	final String? Function(T?)? validator;
	final void Function(T?)? onSaved;
	final void Function(T?)? onChanged;

	SelectFormField({
		required this.options, 
		this.hint, 
		this.label, 
		this.decoration, 
		this.validator, 
		this.onSaved, 
		this.onChanged
	});

	@override
	_SelectFormFieldState createState() => _SelectFormFieldState<T>();
}

class _SelectFormFieldState<T> extends State<SelectFormField<T>> {

	T? value;

	@override
	Widget build(BuildContext context) => DropdownButtonFormField<T>(
		value: value,
		icon: Icon(Icons.keyboard_arrow_down),
		onSaved: widget.onSaved,
		validator: widget.validator,
		decoration: (widget.decoration ?? InputDecoration()).copyWith(
			hintText: widget.hint ?? widget.label ?? 'Select Field',
			labelText: widget.label
		),
		onChanged: (newValue) {
			setState(() => this.value = newValue);
			if (widget.onChanged != null) widget.onChanged!(newValue);
		},
		isExpanded: true,
		items: widget.options.map(
			(option) => DropdownMenuItem(
				value: option,
				child: Text(option.toString())
			)
		).toList()
	);
}

import 'package:flutter/material.dart';

class SelectFormField<T> extends StatefulWidget {
	final String? hint;
	final String? label;
	final List<T> options;

	SelectFormField({
		required this.options, 
		this.hint, 
		this.label
	});

	@override
	_SelectFormFieldState createState() => _SelectFormFieldState<T>();
}

class _SelectFormFieldState<T> extends State<SelectFormField<T>> {

	late T? value;

	@override
	Widget build(BuildContext context) => DropdownButtonFormField<T>(
		value: value,
		icon: Icon(Icons.keyboard_arrow_down),
		decoration: InputDecoration(
			hintText: widget.hint ?? widget.label ?? 'Select Field',
			labelText: widget.label
		),
		onChanged: (newValue) => setState(() => this.value = newValue),
		isExpanded: true,
		items: widget.options.map(
			(option) => DropdownMenuItem(
				value: option,
				child: Text(option.toString())
			)
		).toList()
	);
}
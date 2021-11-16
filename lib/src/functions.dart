import 'package:flutter/material.dart';
import 'package:html/parser.dart';

MaterialColor createMaterialColor(Color color) {
	final int r = color.red, g = color.green, b = color.blue;
	final swatch = <int, Color>{};
	List strengths = <double>[.05];

	for (int i = 1; i < 10; i++) {
		strengths.add(0.1 * i);
	}

	strengths.forEach((strength) {
		final double ds = 0.5 - strength;
		swatch[(strength * 1000).round()] = Color.fromRGBO(
			r + ((ds < 0 ? r : (255 - r)) * ds).round(),
			g + ((ds < 0 ? g : (255 - g)) * ds).round(),
			b + ((ds < 0 ? b : (255 - b)) * ds).round(),
			1,
		);
	});
	return MaterialColor(color.value, swatch);
}

String parseHtmlString(String htmlString) {
	final document = parse(htmlString);
	final String parsedString = parse(document.body.text).documentElement.text;

	return parsedString;
}

String removeAllHtmlTags(String htmlText) {
	RegExp exp = RegExp(
		r"<[^>]*>",
		multiLine: true,
		caseSensitive: true
	);

	return htmlText.replaceAll(exp, '');
}
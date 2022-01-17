library flutter_kick_start;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MintImage extends StatelessWidget {

	final String path;
	final BoxFit fit;
	final double? height;
	final double? width;
	final double? borderRadius;
	final BoxShape? shape;
	final BoxBorder? border;

	MintImage(this.path, {
		this.fit: BoxFit.contain, 
		this.height, 
		this.width, 
		this.borderRadius,
		this.shape,
		this.border
	});

	static Widget circle(String path, {
		BoxFit fit: BoxFit.cover, 
		double? height, 
		double? width,
		BoxBorder? border
	}) => MintImage(
		path, 
		fit: fit, 
		shape: BoxShape.circle,
		width: width, 
		height: height,
		border: border
	);

	@override
	Widget build(BuildContext context) {
		if(this.path.endsWith('.svg')) 
			return svgImage();

		if(Uri.parse(this.path).hasAbsolutePath) 
			return networkImage();

		return assetImage();
	}

	Widget assetImage() => ExtendedImage.asset(
		this.path,
		fit: this.fit,
		width: this.width,
		height: this.height,
		border: this.border,
		shape: this.shape,
		borderRadius: this.borderRadius == null 
			? null 
			: BorderRadius.circular(this.borderRadius!)
	);

	Widget svgImage() {
		if(Uri.parse(this.path).hasAbsolutePath) 
			return SvgPicture.network(
				this.path,
				fit: this.fit,
				width: this.width,
				height: this.height
			);
		
		return SvgPicture.asset(
			this.path,
			fit: this.fit,
			width: this.width,
			height: this.height
		);
	}

	Widget networkImage() => ExtendedImage.network(
		this.path,
		fit: this.fit,
		cache: true,
		width: this.width,
		height: this.height,
		border: this.border,
		shape: this.shape,
		borderRadius: this.borderRadius == null 
			? null 
			: BorderRadius.circular(this.borderRadius!)
	);
}
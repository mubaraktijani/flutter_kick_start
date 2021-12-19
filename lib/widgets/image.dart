import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MintImage extends StatelessWidget {

	final String path;
	final BoxFit? fit;
	final double? height;
	final double? width;
	final double? borderRadius;
	final BoxShape? shape;
	final BoxBorder? border;

	MintImage(this.path, {
		this.fit, 
		this.height, 
		this.width, 
		this.borderRadius,
		this.shape,
		this.border
	});

	static Widget circle(String path, {
		BoxFit? fit, 
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

		final Uri? uri = Uri.tryParse(this.path);
		bool isSVG = this.path.endsWith('.svg');
		bool isNetworkImage = uri != null && uri.hasAbsolutePath;

		if(isNetworkImage) return networkImage();

		if(isSVG) return svgImage();

		return assetImage();
	}

	Widget assetImage() => ExtendedImage.asset(
		this.path,
		fit: BoxFit.fill,
		width: this.width,
		height: this.height,
		border: this.border,
		shape: this.shape,
		borderRadius: this.borderRadius == null 
			? null 
			: BorderRadius.circular(this.borderRadius!)
	);

	Widget svgImage() => Image.asset('name');

	Widget networkImage() => ExtendedImage.network(
		this.path,
		fit: BoxFit.fill,
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
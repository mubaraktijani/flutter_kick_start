library flutter_kick_start;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

export 'package:velocity_x/velocity_x.dart';
export 'package:extended_image/extended_image.dart';
export 'package:flutter_vector_icons/flutter_vector_icons.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:libphonenumber/libphonenumber.dart';

export 'src/widgets/image.dart';
export 'src/widgets/route_page.dart';
export 'src/widgets/select_form_field.dart';
export 'src/widgets/password_form_field.dart';
export 'src/widgets/video_player/video_player.dart';

export 'src/handlers/sizes.dart';
export 'src/handlers/functions.dart';
export 'src/handlers/jwt_helper.dart';

export 'src/lib/service.dart';

GetIt get getIt => GetIt.instance;
FlutterSecureStorage get localStorage => new FlutterSecureStorage();
AndroidOptions get getAndroidOptions => AndroidOptions(
	encryptedSharedPreferences: true,
);


class FlutterKickStart {
	final String? baseUrl;
	final int connectTimeout;
	final int receiveTimeout;

	FlutterKickStart({ 
		this.baseUrl, 
		this.connectTimeout: 20000,
		this.receiveTimeout: 20000 
	});

	void init() {
		if (!getIt.isRegistered(instance: FlutterKickStart)) {
			getIt..registerSingleton<FlutterKickStart>(FlutterKickStart(
				baseUrl: this.baseUrl,
				connectTimeout: this.connectTimeout,
				receiveTimeout: this.receiveTimeout
			));
		}
	}
}
import 'package:flutter/foundation.dart';

import '../authorization_callback_listener.dart';
import 'app_links_callback_listener.dart';
import 'loopback_callback_listener.dart';
import 'web_callback_listener.dart';

AuthorizationCallbackListener createPlatformCallbackListener() {
  if (kIsWeb) return WebCallbackListener(Uri.base);
  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => AppLinksCallbackListener(),
    _ => LoopbackCallbackListener(),
  };
}

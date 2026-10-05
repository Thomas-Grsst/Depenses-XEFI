import 'package:flutter/widgets.dart';

import 'app_route.dart';

Future<T?> openRoute<T>(BuildContext context, AppRoute route, {Object? arguments}) =>
    Navigator.of(context).pushNamed<T>(route.path, arguments: arguments);

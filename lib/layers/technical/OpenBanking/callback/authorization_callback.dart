import 'package:equatable/equatable.dart';

const _codeKey = 'code';
const _stateKey = 'state';
const _errorKey = 'error';

class AuthorizationCallback extends Equatable {
  const AuthorizationCallback({this.code, this.state, this.error});

  factory AuthorizationCallback.fromUri(Uri uri) {
    final parameters = {...uri.queryParameters, ..._fragmentParameters(uri.fragment)};
    return AuthorizationCallback(
      code: _filled(parameters[_codeKey]),
      state: _filled(parameters[_stateKey]),
      error: _filled(parameters[_errorKey]),
    );
  }

  static Uri? uriFromText(String text) {
    final uri = Uri.tryParse(text.trim());
    if (uri == null || AuthorizationCallback.fromUri(uri).isEmpty) return null;
    return uri;
  }

  final String? code;
  final String? state;
  final String? error;

  bool get isEmpty => code == null && state == null && error == null;

  static Map<String, String> _fragmentParameters(String fragment) {
    final start = fragment.indexOf('?');
    if (start < 0) return const {};
    return Uri.splitQueryString(fragment.substring(start + 1));
  }

  static String? _filled(String? value) => value == null || value.isEmpty ? null : value;

  @override
  List<Object?> get props => [code, state, error];
}

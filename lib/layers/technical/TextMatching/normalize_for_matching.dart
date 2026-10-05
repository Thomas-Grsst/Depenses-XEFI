const _accented = 'àâäáãåçéèêëíìîïñóòôöõúùûüýÿœæ';
const _plain = 'aaaaaaceeeeiiiinooooouuuuyyoa';

String normalizeForMatching(String input) {
  final buffer = StringBuffer();
  for (final character in input.toLowerCase().trim().split('')) {
    final index = _accented.indexOf(character);
    buffer.write(index >= 0 ? _plain[index] : character);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
}

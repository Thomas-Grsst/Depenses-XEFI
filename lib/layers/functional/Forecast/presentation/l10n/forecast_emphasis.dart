const _emphasisMarker = '**';

List<(String, bool)> emphasisParts(String text) {
  final segments = text.split(_emphasisMarker);
  return [
    for (var i = 0; i < segments.length; i++)
      if (segments[i].isNotEmpty) (segments[i], i.isOdd),
  ];
}

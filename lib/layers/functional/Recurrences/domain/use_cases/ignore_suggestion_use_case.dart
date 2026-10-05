import '../entities/recurring_suggestion.dart';
import '../gateways/detection_setting_gateway.dart';

class IgnoreSuggestionUseCase {
  IgnoreSuggestionUseCase(this._settings);

  final DetectionSettingGateway _settings;

  Future<void> call(RecurringSuggestion suggestion) => _settings.ignore(suggestion.key);
}

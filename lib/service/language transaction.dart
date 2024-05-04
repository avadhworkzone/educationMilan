import 'package:get/get.dart';

import 'english.dart';
import 'gujarati.dart';

class LanguageTranslation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': gu};
}

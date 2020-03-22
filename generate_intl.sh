flutter pub run intl_translation:extract_to_arb \
   --output-dir=lib/src/resources/intl lib/src/resources/intl/localizations.dart

mv lib/src/resources/intl/intl_messages.arb lib/src/resources/intl/intl_en.arb

flutter pub run intl_translation:generate_from_arb \
   --output-dir=lib/src/resources/intl --no-use-deferred-loading \
   lib/src/resources/intl/localizations.dart lib/src/resources/intl/*.arb

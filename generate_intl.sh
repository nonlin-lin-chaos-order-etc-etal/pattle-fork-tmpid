flutter pub run intl_translation:extract_to_arb \
   --output-dir=lib/src/resources/intl lib/src/resources/intl/localizations.dart

mv lib/src/resources/intl/intl_messages.arb lib/src/resources/intl/intl_en.arb

flutter pub run intl_translation:generate_from_arb \
   --output-dir=lib/src/resources/intl --no-use-deferred-loading \
   lib/src/resources/intl/localizations.dart lib/src/resources/intl/*.arb

echo '// ignore_for_file: avoid_catches_without_on_clauses,type_annotate_public_apis,lines_longer_than_80_chars' \
	| tee -a lib/src/resources/intl/messages*.dart

dartfmt lib/src/resources/intl/messages*.dart -w --fix

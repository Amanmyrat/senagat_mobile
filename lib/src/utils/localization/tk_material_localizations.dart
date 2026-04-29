import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TkMaterialLocalizations extends DefaultMaterialLocalizations {
  @override
  String get localeName => 'tk';

  // ---------- BUTTON LABELS ----------
  @override
  String get okButtonLabel => 'Bolýar';

  @override
  String get cancelButtonLabel => 'Ýatyr';

  @override
  String get closeButtonLabel => 'Ýap';

  @override
  String get todayLabel => 'Şu gün';

  @override
  String get datePickerHelpText => 'Sene Saýlaň';

  @override
  String get dateInputLabel => 'Sene giriziň';

  @override
  String get dateRangeStartLabel => 'Başlangyç sene';

  @override
  String get dateRangeEndLabel => 'Ahyr sene';

  @override
  String get selectYearSemanticsLabel => 'Ýyly saýla';

  @override
  String get selectYearTooltip => 'Ýyly saýla';

  @override
  String get selectYear => 'Ýyly saýla';

  @override
  String get year => 'Ýyl';


  // ---------- WEEKDAYS ----------
  @override
  List<String> get weekdays => const [
    'Duşenbe',
    'Sişenbe',
    'Çarşenbe',
    'Penşenbe',
    'Anna',
    'Juma',
    'Şenbe'
  ];

  @override
  List<String> get shortWeekdays =>
      const ['Duş', 'Siş', 'Çar', 'Pen', 'Ann', 'Jum', 'Şen'];

  @override
  List<String> get narrowWeekdays =>
      const ['D', 'S', 'Ç', 'P', 'A', 'J', 'Ş'];

  // ---------- MONTHS ----------
  @override
  List<String> get months => const [
    'Ýanwar',
    'Fewral',
    'Mart',
    'Aprel',
    'Maý',
    'Iýun',
    'Iýul',
    'Awgust',
    'Sentýabr',
    'Oktýabr',
    'Noýabr',
    'Dekabr',
  ];

  @override
  List<String> get shortMonths => const [
    'Ýan',
    'Few',
    'Mar',
    'Apr',
    'Maý',
    'Iýn',
    'Iýl',
    'Awg',
    'Sen',
    'Okt',
    'Noý',
    'Dek',
  ];
  @override
  String formatMonthYear(DateTime date) {
    const months = [
      'Ýanwar',
      'Fewral',
      'Mart',
      'Aprel',
      'Maý',
      'Iýun',
      'Iýul',
      'Awgust',
      'Sentýabr',
      'Oktýabr',
      'Noýabr',
      'Dekabr'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  String formatMediumDate(DateTime date) {
    const months = [
      'Ýan',
      'Few',
      'Mar',
      'Apr',
      'Maý',
      'Iýun',
      'Iýul',
      'Awg',
      'Sen',
      'Okt',
      'Noý',
      'Dek'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ---------- FORMATTERS (so DatePicker uses your names) ----------
  @override
  String formatShortDate(DateTime date) {
    return '${date.day} ${shortMonths[date.month - 1]} ${date.year}';
  }


  @override
  String formatShortMonthDay(DateTime date) {
    return '${date.day} ${shortMonths[date.month - 1]}';
  }
}

class TkMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const TkMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tk';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return TkMaterialLocalizations();
  }

  @override
  bool shouldReload(_) => false;
}

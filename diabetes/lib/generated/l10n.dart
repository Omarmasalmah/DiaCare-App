// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `World`
  String get world {
    return Intl.message(
      'World',
      name: 'world',
      desc: '',
      args: [],
    );
  }

  /// `Reminders`
  String get reminders {
    return Intl.message(
      'Reminders',
      name: 'reminders',
      desc: '',
      args: [],
    );
  }

  /// `Medication Time`
  String get medication_time {
    return Intl.message(
      'Medication Time',
      name: 'medication_time',
      desc: '',
      args: [],
    );
  }

  /// `Activity Summary`
  String get Activity_summary {
    return Intl.message(
      'Activity Summary',
      name: 'Activity_summary',
      desc: '',
      args: [],
    );
  }

  /// `Steps`
  String get steps {
    return Intl.message(
      'Steps',
      name: 'steps',
      desc: '',
      args: [],
    );
  }

  /// `Exercise`
  String get Exercise {
    return Intl.message(
      'Exercise',
      name: 'Exercise',
      desc: '',
      args: [],
    );
  }

  /// `Calories`
  String get Calories {
    return Intl.message(
      'Calories',
      name: 'Calories',
      desc: '',
      args: [],
    );
  }

  /// `Recent Meal Log`
  String get recent_meal_log {
    return Intl.message(
      'Recent Meal Log',
      name: 'recent_meal_log',
      desc: '',
      args: [],
    );
  }

  /// `Breakfast`
  String get breakfast {
    return Intl.message(
      'Breakfast',
      name: 'breakfast',
      desc: '',
      args: [],
    );
  }

  /// `Lunch`
  String get lunch {
    return Intl.message(
      'Lunch',
      name: 'lunch',
      desc: '',
      args: [],
    );
  }

  /// `Dinner`
  String get dinner {
    return Intl.message(
      'Dinner',
      name: 'dinner',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Insulin Calculation & Calories`
  String get Insulin_calc_calories {
    return Intl.message(
      'Insulin Calculation & Calories',
      name: 'Insulin_calc_calories',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get account_settings {
    return Intl.message(
      'Account Settings',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Frequent Questions About Diabetes`
  String get Frequent_questions {
    return Intl.message(
      'Frequent Questions About Diabetes',
      name: 'Frequent_questions',
      desc: '',
      args: [],
    );
  }

  /// `What is diabetes?`
  String get what_is_diabetes {
    return Intl.message(
      'What is diabetes?',
      name: 'what_is_diabetes',
      desc: '',
      args: [],
    );
  }

  /// `What is the difference between type 1 and type 2 diabetes?`
  String get difference_type1_type2 {
    return Intl.message(
      'What is the difference between type 1 and type 2 diabetes?',
      name: 'difference_type1_type2',
      desc: '',
      args: [],
    );
  }

  /// `What are the symptoms of diabetes?`
  String get symptoms_of_diabetes {
    return Intl.message(
      'What are the symptoms of diabetes?',
      name: 'symptoms_of_diabetes',
      desc: '',
      args: [],
    );
  }

  /// `How can I manage diabetes?`
  String get manage_diabetes {
    return Intl.message(
      'How can I manage diabetes?',
      name: 'manage_diabetes',
      desc: '',
      args: [],
    );
  }

  /// `Can diabetics eat sugar?`
  String get diabetic_eat_sugar {
    return Intl.message(
      'Can diabetics eat sugar?',
      name: 'diabetic_eat_sugar',
      desc: '',
      args: [],
    );
  }

  /// `What are the complications of diabetes if not controlled?`
  String get diabetes_complications_uncontrolled {
    return Intl.message(
      'What are the complications of diabetes if not controlled?',
      name: 'diabetes_complications_uncontrolled',
      desc: '',
      args: [],
    );
  }

  /// `How can I monitor blood sugar levels at home?`
  String get monitor_blood_sugar_home {
    return Intl.message(
      'How can I monitor blood sugar levels at home?',
      name: 'monitor_blood_sugar_home',
      desc: '',
      args: [],
    );
  }

  /// `Should diabetics exercise?`
  String get exercise_for_diabetics {
    return Intl.message(
      'Should diabetics exercise?',
      name: 'exercise_for_diabetics',
      desc: '',
      args: [],
    );
  }

  /// `Are there foods that should be completely avoided?`
  String get foods_to_avoid {
    return Intl.message(
      'Are there foods that should be completely avoided?',
      name: 'foods_to_avoid',
      desc: '',
      args: [],
    );
  }

  /// `Is diabetes hereditary?`
  String get is_diabetes_hereditary {
    return Intl.message(
      'Is diabetes hereditary?',
      name: 'is_diabetes_hereditary',
      desc: '',
      args: [],
    );
  }

  /// `Select User`
  String get select_user {
    return Intl.message(
      'Select User',
      name: 'select_user',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get DOB {
    return Intl.message(
      'Date of Birth',
      name: 'DOB',
      desc: '',
      args: [],
    );
  }

  /// `Language Preference`
  String get LangPref {
    return Intl.message(
      'Language Preference',
      name: 'LangPref',
      desc: '',
      args: [],
    );
  }

  /// `Medication Reminder`
  String get medication_reminder {
    return Intl.message(
      'Medication Reminder',
      name: 'medication_reminder',
      desc: '',
      args: [],
    );
  }

  /// `Blood Glucose Check Reminders`
  String get blood_glucose_check_reminders {
    return Intl.message(
      'Blood Glucose Check Reminders',
      name: 'blood_glucose_check_reminders',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Reminders`
  String get appointment_reminders {
    return Intl.message(
      'Appointment Reminders',
      name: 'appointment_reminders',
      desc: '',
      args: [],
    );
  }

  /// `Physical Activity Reminders`
  String get physical_activity_reminders {
    return Intl.message(
      'Physical Activity Reminders',
      name: 'physical_activity_reminders',
      desc: '',
      args: [],
    );
  }

  /// `Enable Fingerprint Authentication`
  String get enable_fingerprint_authentication {
    return Intl.message(
      'Enable Fingerprint Authentication',
      name: 'enable_fingerprint_authentication',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Contacts`
  String get emergency_contacts {
    return Intl.message(
      'Emergency Contacts',
      name: 'emergency_contacts',
      desc: '',
      args: [],
    );
  }

  /// `SOS Button Settings`
  String get sos_button_settings {
    return Intl.message(
      'SOS Button Settings',
      name: 'sos_button_settings',
      desc: '',
      args: [],
    );
  }

  /// `Hypoglycemia Alerts`
  String get hypoglycemia_alerts {
    return Intl.message(
      'Hypoglycemia Alerts',
      name: 'hypoglycemia_alerts',
      desc: '',
      args: [],
    );
  }

  /// `Diabetes Management`
  String get appTitle {
    return Intl.message(
      'Diabetes Management',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

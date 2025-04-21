import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class S {
  final Locale locale;

  S(this.locale);

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "hello": "Hello",
      "world": "World",
      "reminders": "Reminders",
      "medicationTime": "Medication Time",
      "activitySummary": "Activity Summary",
      "steps": "Steps",
      "exercise": "Exercise",
      "calories": "Calories",
      "recentMealLog": "Recent Meal Log",
      "breakfast": "Breakfast",
      "lunch": "Lunch",
      "dinner": "Dinner",
      "home": "Home",
      "faq": "FAQ",
      "insulinCalcCalories": "Insulin Calculation & Calories",
      "chat": "Chat",
      "accountSettings": "Account Settings",
      "logout": "Logout",
      "frequentQuestions": "Frequent Questions About Diabetes",
      "whatIsDiabetes": "What is diabetes?",
      "differenceType1Type2":
          "What is the difference between type 1 and type 2 diabetes?",
      "symptomsOfDiabetes": "What are the symptoms of diabetes?",
      "manageDiabetes": "How can I manage diabetes?",
      "diabeticEatSugar": "Can diabetics eat sugar?",
      "diabetesComplicationsUncontrolled":
          "What are the complications of diabetes if not controlled?",
      "monitorBloodSugarHome": "How can I monitor blood sugar levels at home?",
      "exerciseForDiabetics": "Should diabetics exercise?",
      "foodsToAvoid": "Are there foods that should be completely avoided?",
      "isDiabetesHereditary": "Is diabetes hereditary?",
      "selectUser": "Select User",
      "name": "Name",
      "email": "Email",
      "phoneNumber": "Phone Number",
      "dob": "Date of Birth",
      "langPref": "Language Preference",
      "medicationReminder": "Medication Reminder",
      "bloodGlucoseCheckReminders": "Blood Glucose Check Reminders",
      "appointmentReminders": "Appointment Reminders",
      "physicalActivityReminders": "Physical Activity Reminders",
      "enableFingerprintAuthentication": "Enable Fingerprint Authentication",
      "changePassword": "Change Password",
      "privacyPolicy": "Privacy Policy",
      "termsAndConditions": "Terms and Conditions",
      "emergencyContacts": "Emergency Contacts",
      "sosButtonSettings": "SOS Button Settings",
      "hypoglycemiaAlerts": "Hypoglycemia Alerts",
      "appTitle": "Diabetes Management",
      "dailyGlucoseLevel": "Daily Glucose Level",
      "insulinCalculator": "Insulin & Calories Calculator",
      "exercises": "Exercises",
      "chart": "Chart",
      "sureToLogout": "Are you sure you want to logout?",
      "insulinCalc": "Insulin & Calories Calculator",
      "whatIsDiabetesAnswer":
          "Diabetes is a chronic disease that occurs when blood sugar (glucose) levels are too high. Glucose comes from food and the body needs the hormone insulin to help transport sugar into cells for energy. In diabetes, the body does not produce enough insulin or does not use it effectively, leading to a buildup of sugar in the blood.",
      "differenceType1Type2Answer":
          "Type 1 diabetes is usually diagnosed in childhood or youth and occurs when the immune system attacks the insulin-producing cells of the pancreas. Type 2 diabetes, on the other hand, often develops in adulthood and is associated with factors such as obesity and inactivity. It occurs when the body becomes resistant to insulin or when insulin production decreases.",
      "symptomsOfDiabetesAnswer":
          "Common symptoms include excessive thirst, frequent urination, fatigue, unexplained weight loss, blurred vision, and slow-healing wounds. Some people may not experience any symptoms, especially with type 2 diabetes.",
      "manageDiabetesAnswer":
          "Managing diabetes involves eating a healthy diet, exercising regularly, monitoring blood sugar levels, and following the doctor's instructions regarding medications or insulin. Lifestyle changes can help control blood sugar levels and reduce the risk of complications.",
      "diabeticEatSugarAnswer":
          "Yes, diabetics can eat sugar in moderation as part of a balanced diet, but it is important to monitor blood sugar levels and ensure that consumption does not cause significant spikes. It is best to consult a doctor for personalized dietary advice.",
      "diabetesComplicationsUncontrolledAnswer":
          "Uncontrolled diabetes can lead to serious complications, such as cardiovascular problems, kidney failure, eye problems (such as retinopathy), nerve damage, and limb amputation. Proper diabetes management helps reduce the risk of these complications.",
      "monitorBloodSugarHomeAnswer":
          "Blood sugar levels can be monitored using a blood glucose meter. Medical guidelines recommend checking blood sugar levels at specific times, such as before and after meals and during physical activity. Some people use continuous monitoring systems that provide real-time blood sugar information.",
      "exerciseForDiabeticsAnswer":
          "Yes, exercise is an important part of managing diabetes as it helps improve the body's sensitivity to insulin and lowers blood sugar levels. It is recommended to engage in at least 150 minutes of moderate physical activity per week. Consult your doctor before starting a new exercise program to ensure safety.",
      "foodsToAvoidAnswer":
          "It is best to avoid foods with added sugars and refined carbohydrates, such as sweets and sodas, as they can cause rapid blood sugar spikes. Instead, focus on consuming complex carbohydrates, proteins, and fiber, which help regulate blood sugar levels.",
      "isDiabetesHereditaryAnswer":
          "Genetics play a role in increasing the risk of diabetes, especially type 2. If a parent or sibling has diabetes, the likelihood of developing it is higher.",
      "languagePreferences": "Language Preferences"
    },
    'ar': {
      "hello": "مرحبا",
      "world": "العالم",
      "reminders": "التذكيرات",
      "medicationTime": "وقت الدواء",
      "activitySummary": "ملخص نشاطك اليومي",
      "steps": "الخطوات",
      "exercise": "التمارين الرياضية",
      "calories": "السعرات الحرارية المحروقة",
      "recentMealLog": "سجل الوجبات الأخير",
      "breakfast": "الإفطار",
      "lunch": "الغداء",
      "dinner": "العشاء",
      "home": "الرئيسية",
      "faq": "الأسئلة الشائعة",
      "insulinCalcCalories": "حساب الأنسولين والسعرات الحرارية",
      "chat": "الدردشة",
      "accountSettings": "إعدادات الحساب",
      "logout": "تسجيل الخروج",
      "frequentQuestions": "أسئلة متكررة عن السكري",
      "whatIsDiabetes": "ما هو السكري؟",
      "differenceType1Type2":
          "ما الفرق بين النوع الأول والنوع الثاني من السكري؟",
      "symptomsOfDiabetes": "ما هي أعراض السكري؟",
      "manageDiabetes": "كيف يمكنني إدارة السكري؟",
      "diabeticEatSugar": "هل يمكن لمريض السكري تناول السكر؟",
      "diabetesComplicationsUncontrolled":
          "ما هي مضاعفات السكري إذا لم يتم التحكم به؟",
      "monitorBloodSugarHome":
          "كيف يمكنني مراقبة مستويات السكر في الدم في المنزل؟",
      "exerciseForDiabetics": "هل يجب على مرضى السكري ممارسة الرياضة؟",
      "foodsToAvoid": "هل هناك أطعمة يجب تجنبها تمامًا؟",
      "isDiabetesHereditary": "هل السكري وراثي؟",
      "selectUser": "اختر المستخدم",
      "name": "الاسم",
      "email": "البريد الإلكتروني",
      "phoneNumber": "رقم الهاتف",
      "dob": "تاريخ الميلاد",
      "langPref": "تفضيل اللغة",
      "medicationReminder": "تذكير الدواء",
      "bloodGlucoseCheckReminders": "تذكيرات فحص السكر في الدم",
      "appointmentReminders": "تذكيرات المواعيد",
      "physicalActivityReminders": "تذكيرات النشاط البدني",
      "enableFingerprintAuthentication": "تفعيل المصادقة ببصمة الإصبع",
      "changePassword": "تغيير كلمة المرور",
      "privacyPolicy": "سياسة الخصوصية",
      "termsAndConditions": "الشروط والأحكام",
      "emergencyContacts": "جهات الاتصال الطارئة",
      "sosButtonSettings": "إعدادات زر الطوارئ",
      "hypoglycemiaAlerts": "تنبيهات انخفاض السكر في الدم",
      "appTitle": "إدارة السكري",
      "dailyGlucoseLevel": "مستويات السكر اليومية الخاصة بك",
      "insulinCalculator": "حساب الأنسولين والسعرات الحرارية",
      "exercises": "التمارين الرياضية",
      "chart": "الرسم البياني",
      "sureToLogout": "هل أنت متأكد أنك تريد تسجيل الخروج؟",
      "insulinCalc": "حساب الأنسولين والسعرات الحرارية",
      "whatIsDiabetesAnswer":
          "السكري هو مرض مزمن يحدث عندما يكون مستوى السكر (الجلوكوز) في الدم مرتفعًا جدًا. يأتي الجلوكوز من الطعام ويحتاج الجسم إلى هرمون الإنسولين الذي يساعد على إدخال السكر إلى الخلايا للحصول على الطاقة. في السكري، لا ينتج الجسم كمية كافية من الإنسولين أو لا يستخدمه بشكل فعال، مما يؤدي إلى تراكم السكر في الدم.",
      "differenceType1Type2Answer":
          "السكري من النوع الأول عادةً ما يُشخَّص في الطفولة أو الشباب ويحدث عندما يهاجم الجهاز المناعي خلايا البنكرياس المنتجة للإنسولين. أما السكري من النوع الثاني، فيتطور غالبًا في سن البلوغ ويرتبط بعوامل مثل السمنة وقلة النشاط، ويحدث عندما يصبح الجسم مقاومًا للإنسولين أو عندما يقل إنتاج الإنسولين.",
      "symptomsOfDiabetesAnswer":
          "تشمل الأعراض الشائعة العطش المفرط، التبول المتكرر، الشعور بالتعب، فقدان الوزن غير المبرر، الرؤية الضبابية، والجروح التي تلتئم ببطء. بعض الأشخاص قد لا يشعرون بأي أعراض خاصة في النوع الثاني من السكري.",
      "manageDiabetesAnswer":
          "يعتمد التحكم بالسكري على تناول نظام غذائي صحي، ممارسة الرياضة بانتظام، مراقبة مستوى السكر في الدم، والالتزام بتعليمات الطبيب بشأن الأدوية أو الإنسولين. يمكن أن تساعد تغييرات نمط الحياة في التحكم في مستوى السكر وتقليل خطر المضاعفات.",
      "diabeticEatSugarAnswer":
          "نعم، يمكن لمرضى السكري تناول السكر باعتدال كجزء من نظام غذائي متوازن، ولكن من المهم مراقبة مستوى السكر في الدم والتأكد من أن الاستهلاك لا يسبب ارتفاعات كبيرة. من الأفضل استشارة الطبيب حول التوجيهات الغذائية الشخصية.",
      "diabetesComplicationsUncontrolledAnswer":
          "يمكن أن يؤدي عدم التحكم بالسكري إلى مضاعفات خطيرة، مثل مشاكل القلب والأوعية الدموية، الفشل الكلوي، مشاكل العين (مثل اعتلال الشبكية)، تلف الأعصاب، وبتر الأطراف. الإدارة الجيدة للسكري تساعد في تقليل خطر هذه المضاعفات.",
      "monitorBloodSugarHomeAnswer":
          "يمكن مراقبة مستوى السكر باستخدام جهاز قياس الجلوكوز في الدم. توصي التوجيهات الطبية بفحص مستويات السكر في أوقات محددة، مثل قبل وبعد الوجبات وأثناء النشاط البدني. بعض الأشخاص يستخدمون أنظمة المراقبة المستمرة التي توفر معلومات لحظية حول مستويات السكر.",
      "exerciseForDiabeticsAnswer":
          "نعم، تُعد الرياضة جزءًا مهمًا من إدارة السكري، حيث تساعد في تحسين حساسية الجسم للإنسولين وخفض مستوى السكر في الدم. يُنصح بممارسة 150 دقيقة على الأقل من النشاط البدني المعتدل أسبوعيًا. يجب استشارة الطبيب قبل البدء ببرنامج رياضي لضمان السلامة.",
      "foodsToAvoidAnswer":
          "يفضل تجنب الأطعمة ذات السكريات المضافة والكربوهيدرات المكررة، مثل الحلويات والمشروبات الغازية، لأنها قد تؤدي إلى ارتفاعات سريعة في مستوى السكر. يمكن تناول الكربوهيدرات المعقدة والبروتينات والألياف التي تساعد على تنظيم مستوى السكر.",
      "isDiabetesHereditaryAnswer":
          "الوراثة تلعب دورًا في زيادة خطر الإصابة بالسكري، خاصة النوع الثاني. إذا كان أحد الوالدين أو الإخوة مصابًا، فإن احتمال الإصابة يكون أعلى.",
      "languagePreferences": "تفضيلات اللغة"
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<S> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(S(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<S> old) {
    return false;
  }
}







// // GENERATED CODE - DO NOT MODIFY BY HAND
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'intl/messages_all.dart';

// // **************************************************************************
// // Generator: Flutter Intl IDE plugin
// // Made by Localizely
// // **************************************************************************

// // ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// // ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// // ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

// class S {
//   S();

//   static S? _current;

//   static S get current {
//     assert(_current != null,
//         'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
//     return _current!;
//   }

//   static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

//   static Future<S> load(Locale locale) {
//     final name = (locale.countryCode?.isEmpty ?? false)
//         ? locale.languageCode
//         : locale.toString();
//     final localeName = Intl.canonicalizedLocale(name);
//     return initializeMessages(localeName).then((_) {
//       Intl.defaultLocale = localeName;
//       final instance = S();
//       S._current = instance;

//       return instance;
//     });
//   }

//   static S of(BuildContext context) {
//     final instance = S.maybeOf(context);
//     assert(instance != null,
//         'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
//     return instance!;
//   }

//   static S? maybeOf(BuildContext context) {
//     return Localizations.of<S>(context, S);
//   }

//   /// `Hello`
//   String get hello {
//     return Intl.message(
//       'Hello',
//       name: 'hello',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `World`
//   String get world {
//     return Intl.message(
//       'World',
//       name: 'world',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Reminders`
//   String get reminders {
//     return Intl.message(
//       'Reminders',
//       name: 'reminders',
//       desc: '',
//       args: [],
//     );
//   }

//   String get dailyGLevel {
//     return Intl.message(
//       'Daily Glucose Level',
//       name: 'dailyGlucoseLevel',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Medication Time`
//   String get medication_time {
//     return Intl.message(
//       'Medication Time',
//       name: 'medication_time',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Activity Summary`
//   String get Activity_summary {
//     return Intl.message(
//       'Activity Summary',
//       name: 'Activity_summary',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Steps`
//   String get steps {
//     return Intl.message(
//       'Steps',
//       name: 'steps',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Exercise`
//   String get Exercise {
//     return Intl.message(
//       'Exercise',
//       name: 'Exercise',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Calories`
//   String get Calories {
//     return Intl.message(
//       'Calories',
//       name: 'Calories',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Recent Meal Log`
//   String get recent_meal_log {
//     return Intl.message(
//       'Recent Meal Log',
//       name: 'recent_meal_log',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Breakfast`
//   String get breakfast {
//     return Intl.message(
//       'Breakfast',
//       name: 'breakfast',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Lunch`
//   String get lunch {
//     return Intl.message(
//       'Lunch',
//       name: 'lunch',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Dinner`
//   String get dinner {
//     return Intl.message(
//       'Dinner',
//       name: 'dinner',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Home`
//   String get home {
//     return Intl.message(
//       'Home',
//       name: 'home',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `FAQ`
//   String get faq {
//     return Intl.message(
//       'FAQ',
//       name: 'faq',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Insulin Calculation & Calories`
//   String get Insulin_calc_calories {
//     return Intl.message(
//       'Insulin Calculation & Calories',
//       name: 'Insulin_calc_calories',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Chat`
//   String get chat {
//     return Intl.message(
//       'Chat',
//       name: 'chat',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Account Settings`
//   String get account_settings {
//     return Intl.message(
//       'Account Settings',
//       name: 'account_settings',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Logout`
//   String get logout {
//     return Intl.message(
//       'Logout',
//       name: 'logout',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Frequent Questions About Diabetes`
//   String get Frequent_questions {
//     return Intl.message(
//       'Frequent Questions About Diabetes',
//       name: 'Frequent_questions',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `What is diabetes?`
//   String get what_is_diabetes {
//     return Intl.message(
//       'What is diabetes?',
//       name: 'what_is_diabetes',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `What is the difference between type 1 and type 2 diabetes?`
//   String get difference_type1_type2 {
//     return Intl.message(
//       'What is the difference between type 1 and type 2 diabetes?',
//       name: 'difference_type1_type2',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `What are the symptoms of diabetes?`
//   String get symptoms_of_diabetes {
//     return Intl.message(
//       'What are the symptoms of diabetes?',
//       name: 'symptoms_of_diabetes',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `How can I manage diabetes?`
//   String get manage_diabetes {
//     return Intl.message(
//       'How can I manage diabetes?',
//       name: 'manage_diabetes',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Can diabetics eat sugar?`
//   String get diabetic_eat_sugar {
//     return Intl.message(
//       'Can diabetics eat sugar?',
//       name: 'diabetic_eat_sugar',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `What are the complications of diabetes if not controlled?`
//   String get diabetes_complications_uncontrolled {
//     return Intl.message(
//       'What are the complications of diabetes if not controlled?',
//       name: 'diabetes_complications_uncontrolled',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `How can I monitor blood sugar levels at home?`
//   String get monitor_blood_sugar_home {
//     return Intl.message(
//       'How can I monitor blood sugar levels at home?',
//       name: 'monitor_blood_sugar_home',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Should diabetics exercise?`
//   String get exercise_for_diabetics {
//     return Intl.message(
//       'Should diabetics exercise?',
//       name: 'exercise_for_diabetics',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Are there foods that should be completely avoided?`
//   String get foods_to_avoid {
//     return Intl.message(
//       'Are there foods that should be completely avoided?',
//       name: 'foods_to_avoid',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Is diabetes hereditary?`
//   String get is_diabetes_hereditary {
//     return Intl.message(
//       'Is diabetes hereditary?',
//       name: 'is_diabetes_hereditary',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Select User`
//   String get select_user {
//     return Intl.message(
//       'Select User',
//       name: 'select_user',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Name`
//   String get name {
//     return Intl.message(
//       'Name',
//       name: 'name',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Email`
//   String get email {
//     return Intl.message(
//       'Email',
//       name: 'email',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Phone Number`
//   String get phoneNumber {
//     return Intl.message(
//       'Phone Number',
//       name: 'phoneNumber',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Date of Birth`
//   String get DOB {
//     return Intl.message(
//       'Date of Birth',
//       name: 'DOB',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Language Preference`
//   String get LangPref {
//     return Intl.message(
//       'Language Preference',
//       name: 'LangPref',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Medication Reminder`
//   String get medication_reminder {
//     return Intl.message(
//       'Medication Reminder',
//       name: 'medication_reminder',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Blood Glucose Check Reminders`
//   String get blood_glucose_check_reminders {
//     return Intl.message(
//       'Blood Glucose Check Reminders',
//       name: 'blood_glucose_check_reminders',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Appointment Reminders`
//   String get appointment_reminders {
//     return Intl.message(
//       'Appointment Reminders',
//       name: 'appointment_reminders',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Physical Activity Reminders`
//   String get physical_activity_reminders {
//     return Intl.message(
//       'Physical Activity Reminders',
//       name: 'physical_activity_reminders',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Enable Fingerprint Authentication`
//   String get enable_fingerprint_authentication {
//     return Intl.message(
//       'Enable Fingerprint Authentication',
//       name: 'enable_fingerprint_authentication',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Change Password`
//   String get change_password {
//     return Intl.message(
//       'Change Password',
//       name: 'change_password',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Privacy Policy`
//   String get privacy_policy {
//     return Intl.message(
//       'Privacy Policy',
//       name: 'privacy_policy',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Terms and Conditions`
//   String get terms_and_conditions {
//     return Intl.message(
//       'Terms and Conditions',
//       name: 'terms_and_conditions',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Emergency Contacts`
//   String get emergency_contacts {
//     return Intl.message(
//       'Emergency Contacts',
//       name: 'emergency_contacts',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `SOS Button Settings`
//   String get sos_button_settings {
//     return Intl.message(
//       'SOS Button Settings',
//       name: 'sos_button_settings',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Hypoglycemia Alerts`
//   String get hypoglycemia_alerts {
//     return Intl.message(
//       'Hypoglycemia Alerts',
//       name: 'hypoglycemia_alerts',
//       desc: '',
//       args: [],
//     );
//   }

//   /// `Diabetes Management`
//   String get appTitle {
//     return Intl.message(
//       'Diabetes Management',
//       name: 'appTitle',
//       desc: '',
//       args: [],
//     );
//   }
// }

// class AppLocalizationDelegate extends LocalizationsDelegate<S> {
//   const AppLocalizationDelegate();

//   List<Locale> get supportedLocales {
//     return const <Locale>[
//       Locale.fromSubtags(languageCode: 'en'),
//       Locale.fromSubtags(languageCode: 'ar'),
//     ];
//   }

//   @override
//   bool isSupported(Locale locale) => _isSupported(locale);
//   @override
//   Future<S> load(Locale locale) => S.load(locale);
//   @override
//   bool shouldReload(AppLocalizationDelegate old) => false;

//   bool _isSupported(Locale locale) {
//     for (var supportedLocale in supportedLocales) {
//       if (supportedLocale.languageCode == locale.languageCode) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

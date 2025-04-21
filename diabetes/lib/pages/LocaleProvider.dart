// import 'package:flutter/material.dart';

// class LocaleProvider with ChangeNotifier {
//   Locale _locale = Locale('en'); // Default locale

//   Locale get locale => _locale;

//   void setLocale(Locale locale) {
//     _locale = locale;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalizationService extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void monitorLanguage(String userId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        String? language = snapshot.data()!['prefLanguage'];
        if (language == 'Arabic') {
          setLocale(const Locale('ar'));
        } else if (language == 'English') {
          setLocale(const Locale('en'));
        }
      }
    });
  }
}

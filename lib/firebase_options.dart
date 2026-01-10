import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAjlP6DtEDnZWd3tstEMu3pcUN8UcU4Ps',
    appId: '1:344199066442:android:dc56c98dbb1be09dbe47b3',
    messagingSenderId: '344199066442',
    projectId: 'chemistry-quiz-app-53b3a',
    databaseURL: 'https://chemistry-quiz-app-53b3a.firebaseio.com',
    storageBucket: 'chemistry-quiz-app-53b3a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAjlP6DtEDnZWd3tstEMu3pcUN8UcU4Ps',
    appId: '1:344199066442:ios:5d64bee3442f001fbe47b3',
    messagingSenderId: '344199066442',
    projectId: 'chemistry-quiz-app-53b3a',
    databaseURL: 'https://chemistry-quiz-app-53b3a.firebaseio.com',
    storageBucket: 'chemistry-quiz-app-53b3a.appspot.com',
    iosBundleId: 'com.example.quizApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBAjlP6DtEDnZWd3tstEMu3pcUN8UcU4Ps',
    appId: '1:344199066442:windows:dc56c98dbb1be09dbe47b3',
    messagingSenderId: '344199066442',
    projectId: 'chemistry-quiz-app-53b3a',
    databaseURL: 'https://chemistry-quiz-app-53b3a.firebaseio.com',
    storageBucket: 'chemistry-quiz-app-53b3a.firebasestorage.app  ',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB684gJTCnhqkJ3viHrzqozgQcCFeWM2y0',
    appId: '1:344199066442:web:aaddf05c993efd1cbe47b3',
    messagingSenderId: '344199066442',
    projectId: 'chemistry-quiz-app-53b3a',
    authDomain: 'chemistry-quiz-app-53b3a.firebaseapp.com',
    databaseURL: 'https://chemistry-quiz-app-53b3a.firebaseio.com',
    storageBucket: 'chemistry-quiz-app-53b3a.firebasestorage.app',
  );
}

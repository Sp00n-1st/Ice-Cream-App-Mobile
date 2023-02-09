import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyAzOmahiQcYKZjFh-q-XgFPkvWSvH0G_UM",
          authDomain: "firestore-63319.firebaseapp.com",
          projectId: "firestore-63319",
          storageBucket: "firestore-63319.appspot.com",
          messagingSenderId: "1006738085803",
          appId: "1:1006738085803:web:7144d53b1c460dc7b664ee");
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:448618578101:android:3ad281c0067ccf97ac3efc',
        apiKey: 'AIzaSyCuu4tbv9CwwTudNOweMNstzZHIDBhgJxA',
        projectId: 'react-native-firebase-testing',
        messagingSenderId: '448618578101',
      );
    }
  }
}

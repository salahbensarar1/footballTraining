
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class FirebaseConfig{
  static Future<void> initializeFirebase() async{
    WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
       options: FirebaseOptions(
         apiKey: 'AIzaSyA0ld4bnw5JlxBhHShltnH32jR6M3X8Gns',
         appId: '1:388672883836:android:921dacc8854523f37e0df9',
         messagingSenderId: '388672883836',
         projectId: 'foottraining-4051b',
         storageBucket: 'foottraining-4051b.firebasestorage.app',
       )
   );
  }
}
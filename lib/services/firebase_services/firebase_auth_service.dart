import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ea_mobile_app/models/firebase_models/firebase_auth_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuthUser firebaseUserToFirebaseAuthUser(FirebaseUser user) {
    return user != null ? FirebaseAuthUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<FirebaseAuthUser> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => firebaseUserToFirebaseAuthUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      FirebaseAuthUser firebaseAuthUser =
          await _auth.signInAnonymously() != null
              ? firebaseUserToFirebaseAuthUser(
                  (await _auth.signInAnonymously()).user)
              : null;
      prefs.setString("firebaseUserId", firebaseAuthUser.uid);
      print("firebaseUserId: ${prefs.getString("firebaseUserId")}");
      return firebaseAuthUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

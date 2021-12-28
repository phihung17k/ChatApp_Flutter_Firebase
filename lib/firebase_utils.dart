import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUtils {
  static Future<User?> signInWithGoogle() async {
    User? user;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = userCredential.user;
    }
    return user;
  }

  static Future logout() async {
    if (await GoogleSignIn().isSignedIn() == true) {
      await GoogleSignIn().disconnect();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
  }

  static Future saveUser(User user) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .get();
    if(result.docs.isEmpty){
      //for new user
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
        {
          "uid": user.uid,
          "displayName": user.displayName,
          "photoURL": user.photoURL,
          "email": user.email,
        }
      );
    }
  }
}

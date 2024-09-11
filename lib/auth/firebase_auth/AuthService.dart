import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {

    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser
            .authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
            credential);

        final String uid = userCredential.user!.uid;

        final DocumentSnapshot userDoc = await _firestore.collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          print("User data: $userData");
        } else {
          print("User Data Not Found!!");

        }
      }
    } catch (e) {
      print("Error Google Sign In: $e");
    }
    return null;
  }

  Future<UserCredential> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final UserCredential result = await _auth.signInWithProvider(githubProvider);
      final User? user = result.user;
      if (user != null) {
        print("GitHub login successful: ${user.uid}");
        return result;
      } else {
        throw FirebaseAuthException(code: 'ERROR', message: 'GitHub sign-in failed');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}

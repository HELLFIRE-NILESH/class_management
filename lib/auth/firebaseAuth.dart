import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signInWithEmail(
      String email,
      String password,
      Function onSuccess,
      Function(String) onError,
      ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        // Log the exception code and message for debugging
        print('FirebaseAuthException caught: ${e.code}, ${e.message}');
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'user-disabled':
            errorMessage = "This user account has been disabled.";
            break;

          case 'invalid-credential':
            errorMessage = "Incorrect email or password provided.";
            break;
          case 'network-request-failed':
            errorMessage = "Network error, please try again later.";
            break;
          case 'too-many-requests':
            errorMessage = "Too many attempts. Please try again later.";
            break;
          default:
            errorMessage = "An unknown error occurred.";
        }
        onError(errorMessage);
      } else {
        // Log non-FirebaseAuthException errors
        print('Non-FirebaseAuthException caught: ${e.toString()}');
        onError("An unknown error occurred: ${e.toString()}");
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

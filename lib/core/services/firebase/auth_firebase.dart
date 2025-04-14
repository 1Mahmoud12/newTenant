// import 'dart:developer';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:dobzz_seller/core/network/errors/failures.dart';
// import 'package:dobzz_seller/core/utils/custom_show_toast.dart';
//
// class AuthenticationService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   UserCredential? userCredential;
//
//   Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
//     try {
//       userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential!;
//     } on FirebaseAuthException catch (e) {
//       // Handle errors
//       if (e.code == 'weak-password') {
//         log('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         log('The account already exists for that email.'.tr());
//       }
//       // ...
//       rethrow;
//     } catch (e) {
//       log('$e');
//       throw ServerFailure(e.toString());
//     }
//   }
//
//   Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return userCredential!;
//     } on FirebaseAuthException catch (e) {
//       // Handle errors
//       if (e.code == 'user-not-found') {
//         log('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         log('Wrong password provided.');
//       }
//       // ...
//       throw ServerFailure(e.code);
//     } catch (e) {
//       log('$e');
//       throw ServerFailure(e.toString());
//     }
//   }
//
//   // Sign in with phone number Used in Register Screen
//   Future<void> verifyPhoneNumber(
//     String phoneNumber,
//     BuildContext context,
//     String countryCode, {
//     FocusNode? focusNode,
//     void Function(String verificationId, int? forceResendingToken)? codeSent,
//     void Function(String verificationId)? codeAutoRetrievalTimeout,
//   }) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: '$countryCode$phoneNumber',
//         verificationCompleted: (phoneAuthCredential) async {
//           await _auth.signInWithCredential(phoneAuthCredential);
//         },
//         verificationFailed: (error) {
//           focusNode?.unfocus();
//           customShowToast(context, error.code, showToastStatus: ShowToastStatus.error);
//         },
//         codeSent: (verificationId, forceResendingToken) {
//           log('================    $verificationId =================');
//           codeSent?.call(verificationId, forceResendingToken);
//         },
//         codeAutoRetrievalTimeout: (verificationId) {
//           log('================    $verificationId =================');
//           if (context.mounted) {
//             if (verificationId != '') {
//               codeAutoRetrievalTimeout?.call(verificationId);
//             }
//             //  closeDialog(context);
//           }
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       focusNode?.unfocus();
//
//       // Handle errors
//       if (e.code == 'user-not-found') {
//         log('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         log('Wrong password provided.');
//       }
//       // ...
//       rethrow;
//     } catch (e) {
//       focusNode?.unfocus();
//
//       log('$e');
//       customShowToast(context, 'Ops, Error in Firebase'.tr(), showToastStatus: ShowToastStatus.error);
//     }
//   }
//
//   Future<UserCredential> verifyOTP(String verificationId, String otp, BuildContext context) async {
//     final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: otp,
//     );
//
//     try {
//       userCredential = await _auth.signInWithCredential(credential);
//       return userCredential!;
//     } on FirebaseAuthException catch (e) {
//       customShowToast(context, e.code, showToastStatus: ShowToastStatus.error);
//       rethrow;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

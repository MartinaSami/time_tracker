import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andreafirst/services/auth.dart';

class SignInManager {
  final AuthBase auth;
final ValueNotifier<bool> isLoading;


  SignInManager({ @required this.isLoading, @required this.auth, });


Future<User> _signIn(Future<User> Function () signImMethod) async{
  try {
    isLoading.value =  true;
    return  await signImMethod();
  } catch (error) {
    isLoading.value =  false;
    rethrow;
  }
}
  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle()async => await _signIn(auth.signInWithGoogle);
}

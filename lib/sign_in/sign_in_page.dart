import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andreafirst/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_andreafirst/services/auth.dart';

import 'package:flutter_andreafirst/sign_in/email_sign_in_page.dart';
import 'package:flutter_andreafirst/sign_in/sign_in_manager.dart';
import 'package:flutter_andreafirst/sign_in/sign_in_button.dart';
import 'package:flutter_andreafirst/sign_in/social_sign_in_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;

  const SignInPage({@required this.manager, @required this.isLoading});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
         context, title: 'Sign in Failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (error) {
      _showSignInError(context, error);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (error) {
      _showSignInError(context, error);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Time Tracker",
            ),
          ),
          body: _buildContent(context),
        ));
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(
              height: 50,
            ),
            SocialSignInButton(
              assetName: 'assets/google.png',
              text: 'Sign in With Google',
              color: Colors.white,
              textColor: Colors.black,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(
              height: 8,
            ),
            SocialSignInButton(
              assetName: 'assets/fb.jpg',
              text: 'Sign in With Facebook',
              color: Colors.indigo,
              textColor: Colors.white,
              onPressed: () {},
            ),
            SizedBox(
              height: 8,
            ),
            SignInButton(
              text: 'Sign in With Email',
              color: Colors.cyan,
              textColor: Colors.black,
              onPressed: isLoading ? null : () => _signInWithEmail(context),
            ),
            SizedBox(
              height: 8,
            ),
            SignInButton(
              text: 'Go Anonymous',
              color: Colors.blue,
              textColor: Colors.black,
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
    );
  }
}

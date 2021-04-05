import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_andreafirst/common_widgets/form_submit_button.dart';

import 'package:flutter_andreafirst/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_andreafirst/services/auth.dart';
import 'package:flutter_andreafirst/sign_in/email_sign_in_model.dart';

import 'package:flutter_andreafirst/sign_in/validators.dart';
import 'package:provider/provider.dart';



class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  @override
  EmailSignInFormStatefulState createState() => EmailSignInFormStatefulState();
}

class EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  //bool isSubmitButtonPressed =  false;
  bool _isLoading = false;

  @override
  void dispose() {

    print('Dispose was called');
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        final auth = Provider.of<AuthBase>(context, listen: false);
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      showExceptionAlertDialog( context, title: 'Sign in Failed', exception: error);
      //showExceptionAlertDialog(context: context, title: 'Sign in Failed', exception: error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Don\'t have an account? Register'
        : 'Already have an account? Login';
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    bool showErrorText = widget.emailValidator.isValid(_email);
    bool showError = widget.passwordValidator.isValid(_password);

    return [
      TextField(
        focusNode: _emailFocusNode,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: 'Enter your email',
          labelText: 'Email',
          errorText: showErrorText ? null : widget.inValidEmailErrorText,
          enabled: _isLoading == false,
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        onChanged: (email) => updateState(),
        onEditingComplete: _emailEditingComplete,
        textInputAction: TextInputAction.next,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextField(
          focusNode: _passwordFocusNode,
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            labelText: 'Password',
            errorText: showError ? null : widget.inValidPasswordErrorText,
            enabled: _isLoading == false,
          ),
          obscureText: true,
          onChanged: (password) => updateState(),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onEditingComplete: _submit),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit : null,
        text: (primaryText),
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(
          secondaryText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void updateState() {
    setState(() {});
  }
}

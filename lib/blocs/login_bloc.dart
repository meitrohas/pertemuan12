import 'dart:async';
import 'package:pertemuan12/classes/validators.dart';
import 'package:pertemuan12/services/authentication_api.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email = '';
  String _password = '';
  bool _emailValid = false;
  bool _passwordValid = false;

  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController = StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController = StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton => _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController = StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    password.listen((password) {
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action == 'Login' ? _logIn() : _createAccount();
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    enableLoginCreateButtonChanged.add(_emailValid && _passwordValid);
  }

  Future<String> _logIn() async {
    if (_emailValid && _passwordValid) {
      try {
        await authenticationApi.signInWithEmailAndPassword(
            email: _email, password: _password);
        return 'Success';
      } catch (error) {
        print('Login error: $error');
        return error.toString();
      }
    } else {
      return 'Email and Password are not valid';
    }
  }

  Future<String> _createAccount() async {
    if (_emailValid && _passwordValid) {
      try {
        await authenticationApi.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await authenticationApi.signInWithEmailAndPassword(
            email: _email, password: _password);
        return 'Account created and logged in';
      } catch (error) {
        print('Error creating account: $error');
        return error.toString();
      }
    } else {
      return 'Email and Password are not valid';
    }
  }
}

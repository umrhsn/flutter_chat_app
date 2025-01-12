import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/const.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/media_service.dart';
import 'package:flutter_chat_app/services/navigation_service.dart';
import 'package:flutter_chat_app/widgets/custom_form_field.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;

  String? email, password, name;
  File? selectedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            _headerText(),
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Register an account using the form below..",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              hintText: "Name",
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegExp: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              hintText: "Email",
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegExp: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              hintText: "Password",
              height: MediaQuery.of(context).size.height * 0.1,
              validationRegExp: PASSWORD_VALIDATION_REGEX,
              obscureText: true,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (_registerFormKey.currentState?.validate() ??
                // ignore: dead_code
                false && selectedImage != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signUp(email!, password!);
              if (result) {
                debugPrint("$result");
              }
            }
          } catch (e) {
            debugPrint('$e');
          }
          setState(() {
            isLoading = false;
          });
        },
        child: Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Already have an account? "),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: Text(
              'Log In',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

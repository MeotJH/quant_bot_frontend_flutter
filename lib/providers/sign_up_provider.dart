import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/sign_up_model/sign_up_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/services/sign_up_service.dart';

final signUpFormProvider = StateNotifierProvider<SignUpFormNotifier, SignUpModel>(
  (ref) => SignUpFormNotifier(),
);

class SignUpFormNotifier extends StateNotifier<SignUpModel> {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordDuplicateController;
  final TextEditingController mobileController;

  SignUpFormNotifier()
      : nameController = TextEditingController(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        passwordDuplicateController = TextEditingController(),
        mobileController = TextEditingController(),
        super(SignUpModel(email: '', password: '', name: '', mobile: '')) {
    emailController.addListener(() {
      state = state.copyWith(email: emailController.text);
    });
    passwordController.addListener(() {
      state = state.copyWith(password: passwordController.text);
    });
    nameController.addListener(() {
      state = state.copyWith(name: nameController.text);
    });
    mobileController.addListener(() {
      state = state.copyWith(mobile: mobileController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    passwordDuplicateController.dispose();
    super.dispose();
  }
}

final signUpProvider = AsyncNotifierProvider.autoDispose.family<SignUpNotifier, void, SignUpModel>(SignUpNotifier.new);

class SignUpNotifier extends AutoDisposeFamilyAsyncNotifier<void, SignUpModel> {
  @override
  Future<void> build(SignUpModel model) async {
    final dio = ref.read(dioProvider);
    final response = await SignUpService(model: model).signUp(dio: dio);
  }
}

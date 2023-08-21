import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../authentication/repository.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.authRepository})
      : super(const AsyncData(null));
  final FakeAuthRepository authRepository;

  Future<void> signIn(
      {required BuildContext context,
      required bool anonymous,
      String? email,
      String? password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signIn(
        context: context,
        email: email,
        password: password,
        anonymous: anonymous));
  }
}

final signInScreenControllerProvider =
    StateNotifierProvider.autoDispose<SignInScreenController, AsyncValue<void>>(
        (ref) {
  return SignInScreenController(
      authRepository: ref.watch(authRepositoryProvider));
});

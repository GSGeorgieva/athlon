import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authentication/repository.dart';
import 'account_screen.dart';
import 'sign_in_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.maybeWhen(
        data: (user) =>
            user != null ? AccountScreen(user: user) : const SignInScreen(),
        orElse: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator())));
  }
}

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/in_memory_store.dart';
import 'app_user.dart';

class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  Future<void> signIn(
      {required BuildContext context,
      required bool anonymous,
      String? email,
      String? password}) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      if (anonymous) {
        _authState.value = AppUser(anonymous: true);
      } else {
        final String response =
            await rootBundle.loadString('assets/json/users.json');
        final data = await json.decode(response);
        List<AppUser> users = [];
        data["users"].forEach((u) => users.add(AppUser.fromJson(u)));
        final AppUser? current = users.firstWhereOrNull(
            (e) => e.email == email && e.password == password);
        if (current == null) {
          _authState.value = null;
          await _getDialog(context, 'User does not exists!');
        } else {
          _authState.value = AppUser(
              uid: current.uid,
              email: current.email,
              password: current.password,
              anonymous: false);
        }
      }
    } catch (e) {
      await _getDialog(context, e.toString());
    }
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  _getDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'))
        ],
      ),
    );
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

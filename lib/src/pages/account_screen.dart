import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../authentication/app_user.dart';
import 'account_screen_controller.dart';
import '../utils/async_value_ui.dart';

class AccountScreen extends ConsumerWidget {
  final AppUser user;

  const AccountScreen({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(accountScreenControllerProvider,
        (_, state) => state.showSnackbarOnError(context));
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
        persistentFooterButtons: [
          SizedBox(
              height: 40,
              width: 120,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          ref
                              .read(accountScreenControllerProvider.notifier)
                              .signOut();
                        },
                  child: Text(!user.anonymous! ? 'Log Out' : 'Log In')))
        ],
        appBar: AppBar(
            title: state.isLoading
                ? const CircularProgressIndicator()
                : const Text('Settings')),
        body: Center(
            child: Column(children: [
          !user.anonymous!
              ? Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child:
                      const CircleAvatar(radius: 30, child: Icon(Icons.person)))
              : Column(children: [
                  Container(height: 50),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text('You are not logged in',
                          style: TextStyle(fontSize: 30)))
                ]),
          Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: TextField(
                  enabled: false,
                  controller: TextEditingController()..text = user.email ?? '',
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'))),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                  controller: TextEditingController()
                    ..text = user.password ?? '',
                  obscureText: true,
                  decoration: const InputDecoration(
                      enabled: false,
                      border: OutlineInputBorder(),
                      labelText: 'Password'))),
          Container(
              alignment: Alignment.topLeft,
              child: TextButton(onPressed: () {}, child: const Text('Change')))
        ])));
  }
}

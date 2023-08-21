import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sign_in_controller.dart';
import '../utils/async_value_ui.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(signInScreenControllerProvider,
        (_, state) => state.showSnackbarOnError(context));
    final state = ref.watch(signInScreenControllerProvider);

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              Container(height: 50),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text('Welcome', style: TextStyle(fontSize: 30))),
              Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email Address'))),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password'))),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: state.isLoading
                          ? null
                          : () => ref
                              .read(signInScreenControllerProvider.notifier)
                              .signIn(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  anonymous: false),
                      child: const Text('Login'))),
              TextButton(
                  onPressed: () {}, child: const Text('Forgot Password')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: const Divider(color: Colors.black26)),
                  const Text('or'),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: const Divider(color: Colors.black38))
                ],
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white),
                      onPressed: state.isLoading
                          ? null
                          : () => ref
                              .read(signInScreenControllerProvider.notifier)
                              .signIn(context: context, anonymous: true),
                      child: const Text(
                        'Explore The App',
                        style: TextStyle(color: Colors.black38),
                      ))),
            ])));
  }
}

import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/pages/auth/auth_wrapper.dart';
import 'package:fasko_mobile/pages/home/home_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // present current state/user
    final user = context.watch<FaskoUser?>();

    if (user == null) {
      return const AuthWrapper(); // if not
    }

    // if logged in
    return const HomeWrapper();
    /*
    removed to main
    return StreamProvider<UserData>.value(
      initialData: UserData(
        lists: [],
        settings: UserSettings(
          work: 30,
          rest: 5,
        ),
      ),
      value: DatabaseService(uid: user.uid).userData,
      child: const HomeWrapper(),
    );
    */
  }
}

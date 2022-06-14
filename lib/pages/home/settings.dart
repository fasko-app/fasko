import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/user_data.dart';
import 'package:fasko_mobile/services/auth.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:fasko_mobile/services/local_storage.dart';
import 'package:fasko_mobile/widgets/icons.dart';
import 'package:fasko_mobile/widgets/number_picker.dart';
import 'package:fasko_mobile/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.toggleView}) : super(key: key) {
    localStorage = LocalStorageService();
  }

  final Function toggleView;
  late final LocalStorageService localStorage;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// icon 'clear'

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // passwords
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();

  void clearText() {
    oldPassword.clear();
    newPassword.clear();
    confirmNewPassword.clear();
  }

  // password eye
  bool isPasswordInvisible = true;

  // timer settings input
  int? workTime;
  int? restTime;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FaskoUser?>()!;
    final AuthService auth = context.read<AuthService>();
    final userData = context.watch<UserData>();

    return Scaffold(
      appBar: FaskoAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => widget.toggleView('home'),
          ),
          const Padding(padding: EdgeInsets.only(right: 5)),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 15, top: 25),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.3),
              ),
            ),
            Text(
              user.name ?? 'Name is not setted up',
              style: const TextStyle(fontSize: 18, height: 1.3),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: Text(
                user.email ?? 'Email is not setted up',
                style: const TextStyle(fontSize: 18, height: 1.3),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    widget.localStorage.clear();
                    auth.signOut();
                    //Navigator.popAndPushNamed(context, '/');
                  },
                  child: const Text(
                    'Sign out',
                    style: TextStyle(
                      color: Color.fromARGB(255, 193, 54, 86),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Timer',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.3),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Work mins', style: TextStyle(fontSize: 18, height: 1.3)),
                Text('Rest mins', style: TextStyle(fontSize: 18, height: 1.3)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NumberPicker(
                  start: (userData.settings.work / 5 - 1).toInt(),
                  min: 5,
                  max: 60,
                  step: 5,
                  margin: const EdgeInsets.only(right: 5, top: 15, bottom: 15),
                  onSelectedItemChanged: (value) => setState(() {
                    workTime = (value + 1) * 5; // 5 = step, (value + 1) = count
                  }),
                ),
                NumberPicker(
                  start: (userData.settings.rest / 5 - 1).toInt(),
                  min: 5,
                  max: 30,
                  step: 5,
                  margin: const EdgeInsets.only(left: 5, top: 15, bottom: 15),
                  onSelectedItemChanged: (value) => setState(() {
                    restTime = (value + 1) * 5;
                  }),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if (workTime != null || restTime != null) {
                      await context.read<DatabaseService>().updateSettings(
                            workTime ?? userData.settings.work,
                            restTime ?? userData.settings.rest,
                          );
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Color.fromARGB(255, 193, 54, 86),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Change password',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.3),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  PasswordInput(
                    controller: oldPassword,
                    text: "Old password",
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Old password can't be empty";
                      }
                      return null;
                    },
                  ),
                  PasswordInput(
                    controller: newPassword,
                    text: "New password",
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "New password can't be empty";
                      }
                      return null;
                    },
                  ),
                  PasswordInput(
                    controller: confirmNewPassword,
                    text: "Confirm new password",
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "New confirm password can't be empty";
                      }
                      if (value != newPassword.text) {
                        return 'Does not match';
                      }
                      return null;
                    },
                  ),
                  Row(
                    textBaseline: TextBaseline.ideographic,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            auth.updatePassword(oldPassword.text, newPassword.text).then((value) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(value ?? ''),
                                ),
                              );
                              if (value == "Password successfuly changed") {
                                clearText();
                              }
                            });
                          }
                        },
                        child: const Text('Update password', style: TextStyle(fontSize: 16)),
                      ),
                      TextButton(
                        onPressed: () async {
                          await auth.resetPassword();
                        },
                        child: const Text(
                          'Send password reset email',
                          style: TextStyle(color: Color.fromARGB(255, 193, 54, 86)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(height: 40),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'About',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.3),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fasko is made by Roman Koshchei. You can find me on:',
                        style: TextStyle(fontSize: 18, height: 1.3),
                      ),
                      TextButton.icon(
                        onPressed: () async => await launchUrl(
                            Uri.parse('https://www.youtube.com/channel/UC3fVQekBlfHMwAww264qtzQ')),
                        icon: const Icon(
                          CustomIcons.youtube,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'YouTube',
                          style: TextStyle(
                              fontSize: 18,
                              height: 1.3,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async =>
                            await launchUrl(Uri.parse('https://github.com/roman-koshchei')),
                        icon: const Icon(
                          CustomIcons.github,
                          color: Color.fromARGB(255, 26, 37, 59),
                        ),
                        label: const Text(
                          'GitHub',
                          style: TextStyle(
                              fontSize: 18,
                              height: 1.3,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: AssetImage('assets/img/me.png'), fit: BoxFit.fill),
                  ),
                ),
                // Container(
                //   width: 50,
                //   height: 50,
                //   child: Image.network('https://avatars.githubusercontent.com/u/103932583?v=4'),
                // ),
              ],
            ),
            const Divider(height: 40),
          ],
        ),
      ),
    );
  }
}

/* theme toggle
TextButton.icon(
              onPressed: () {
                setState(() {
                  isDarkTheme = !isDarkTheme;
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              label: isDarkTheme
                  ? const Text('Light theme', style: TextStyle(fontSize: 18))
                  : const Text('Dark theme', style: TextStyle(fontSize: 18)),
              icon:
                  isDarkTheme ? const Icon(Icons.toggle_off_outlined) : const Icon(Icons.toggle_on),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'My lists',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
*/

/* lists
 Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: ValueKey(index),
                    onDismissed: (direction) {
                      setState(() {
                        // remove list from db
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(
                        'List $index',
                        textAlign: TextAlign.start,
                      ), // there will be task view
                    ),
                  );
                },
              ),
            ),
 */

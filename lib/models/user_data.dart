/*
 * UserData contains user fields from database
 * Doesn't contain email, display name, password 
 */

import 'package:fasko_mobile/models/run.dart';
import 'package:fasko_mobile/models/user_settings.dart';

class UserData {
  final Run? run;
  final UserSettings settings;
  final List<String> lists;

  UserData({
    required this.lists,
    this.run,
    required this.settings,
  });
}

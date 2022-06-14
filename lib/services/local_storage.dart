import 'package:fasko_mobile/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  void setShowLists(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('showLists', value);
  }

  Future<List<String>> getShowLists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('showLists') ?? [];
  }

  void setSortCompare(Function? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == Task.compareByDate) {
      await prefs.setString('sortCompare', 'date');
    } else if (value == Task.compareByLevel) {
      await prefs.setString('sortCompare', 'level');
    }
  }

  Future<Function?> getSortCompare() async {
    final prefs = await SharedPreferences.getInstance();
    String? sortCompareStr = prefs.getString('sortCompare');
    if (sortCompareStr != null) {
      return sortCompareStr == 'date' ? Task.compareByDate : Task.compareByLevel;
    }
    return null;
  }

  void clear() {
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
  }
}

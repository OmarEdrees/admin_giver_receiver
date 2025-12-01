import 'package:shared_preferences/shared_preferences.dart';

class HideItemManager {
  static const String key = "hidden_items";

  static Future<List<String>> _getHiddenItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<bool> isItemHidden(String itemId) async {
    final list = await _getHiddenItems();
    return list.contains(itemId);
  }

  static Future<void> toggleHideItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getHiddenItems();

    if (list.contains(itemId)) {
      list.remove(itemId);
    } else {
      list.add(itemId);
    }

    await prefs.setStringList(key, list);
  }
}

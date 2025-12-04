// import 'package:shared_preferences/shared_preferences.dart';

// class HideItemManager {
//   static const String key = "hidden_items";

//   static Future<List<String>> _getHiddenItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(key) ?? [];
//   }

//   static Future<bool> isItemHidden(String itemId) async {
//     final list = await _getHiddenItems();
//     return list.contains(itemId);
//   }

//   static Future<void> toggleHideItem(String itemId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final list = await _getHiddenItems();

//     if (list.contains(itemId)) {
//       list.remove(itemId);
//     } else {
//       list.add(itemId);
//     }

//     await prefs.setStringList(key, list);
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';

class HideItemManager {
  static final supabase = Supabase.instance.client;

  static Future<bool> isItemHidden(String itemId) async {
    final result = await supabase
        .from('user_items')
        .select('is_hidden')
        .eq('id', itemId)
        .maybeSingle();

    return (result?['is_hidden'] ?? false) as bool;
  }

  static Future<void> toggleHideItem(String itemId) async {
    final current = await isItemHidden(itemId);

    await supabase
        .from('user_items')
        .update({'is_hidden': !current})
        .eq('id', itemId);
  }
}

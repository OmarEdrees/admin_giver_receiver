import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ItemsServices {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> categoriesList = [];
  final bucket = "add_items_images";
  ////////////////////////////////////////////////////////////////////
  Future<String?> uploadImage({
    required File file,
    required String userId,
  }) async {
    final fileName =
        'add_items_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from(bucket).upload(fileName, file);
    return supabase.storage.from(bucket).getPublicUrl(fileName);
  }

  ////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getAllItems() async {
    try {
      final response = await supabase
          .from('user_items')
          .select()
          .order('created_at', ascending: false); // لترتيب الأحدث أولاً

      // التأكد من أن النتيجة ليست فارغة
      if (response.isEmpty) {
        print('No items found for user');
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get Items Error: $e');
      return null;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<bool> deleteItem(String itemId) async {
    try {
      final supabase = Supabase.instance.client;

      // حذف الصور من التخزين قبل حذف العنصر (اختياري)
      final itemData = await supabase
          .from('user_items')
          .select('images')
          .eq('id', itemId)
          .single();

      final List<dynamic>? images = itemData['images'];

      if (images != null && images.isNotEmpty) {
        for (var imgUrl in images) {
          final String fileName = imgUrl.split('/').last;
          await supabase.storage.from('add_items_images').remove([fileName]);
        }
      }

      // حذف العنصر من الجدول
      await supabase.from('user_items').delete().eq('id', itemId);

      return true;
    } catch (e) {
      print('ERROR DELETE ITEM: $e');
      return false;
    }
  }

  ////////////////////////////////////////////////////////////
  Future<void> loadItems() async {
    final items = await getAllItems();
    allItems = items ?? [];
    filteredItems = allItems;
  }

  Future<void> loadCategories() async {
    final response = await Supabase.instance.client.from('categories').select();
    categoriesList = response;
  }

  void applyFilters({String? condition, String? categoryId}) {
    List<Map<String, dynamic>> temp = allItems;

    if ((condition != null && condition.isNotEmpty) ||
        (categoryId != null && categoryId.isNotEmpty)) {
      temp = temp.where((item) {
        final matchesCondition = condition != null && condition.isNotEmpty
            ? item['condition'] == condition
            : false;
        final matchesCategory = categoryId != null && categoryId.isNotEmpty
            ? item['category_id'] == categoryId
            : false;
        return matchesCondition || matchesCategory;
      }).toList();
    }

    filteredItems = temp;
  }

  void searchItems(String query) {
    final search = query.toLowerCase();
    if (query.isEmpty) {
      filteredItems = allItems;
    } else {
      filteredItems = allItems.where((item) {
        final title = item['title'].toString().toLowerCase();
        final desc = item['description'].toString().toLowerCase();
        return title.contains(search) || desc.contains(search);
      }).toList();
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

class RequestsScreenServices {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllRequestsForAdmin() async {
    try {
      final response = await supabase
          .from('requests')
          .select('''
      id,
      reason,
      attachment_url,
      status,
      created_at,
      item_id,
      donor_id,
      requester_id,
      user_items(title),
      donor:users!requests_donor_id_fkey(id, full_name,image),
      requester:users!requests_requester_id_fkey(id, full_name,image)
    ''')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Get Requests Error: $e");
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<bool> updateStatus(String reqId, String status) async {
    try {
      await supabase
          .from('requests')
          .update({"status": status})
          .eq('id', reqId);

      return true;
    } catch (e) {
      print("Update Status Error: $e");
      return false;
    }
  }
}

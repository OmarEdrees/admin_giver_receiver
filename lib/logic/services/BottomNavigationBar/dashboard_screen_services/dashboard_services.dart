import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class DashboardService {
  final supabase = Supabase.instance.client;

  // إجمالي المتبرعين
  Future<int> getTotalDonors() async {
    final List data = await supabase
        .from('users')
        .select('id')
        .eq('role', 'Donor');

    return data.length;
  }

  ///////////////////////////
  Future<String> getLastDonorsUpdate() async {
    final List res = await supabase
        .from('users')
        .select('created_at')
        .eq('role', 'Donor')
        .order('created_at', ascending: false)
        .limit(1);

    if (res.isEmpty) return '—';

    final date = DateTime.parse(res.first['created_at']);
    return 'Update: ${DateFormat('dd MMM yyyy').format(date)}';
  }

  // إجمالي طالبي الخدمة
  Future<int> getTotalServiceSeekers() async {
    final res = await supabase
        .from('users')
        .select('id')
        .eq('role', 'Recipient');

    return res.length;
  }

  //////////////////////////////////
  Future<String> getLastSeekersUpdate() async {
    final List res = await supabase
        .from('users')
        .select('created_at')
        .eq('role', 'Recipient')
        .order('created_at', ascending: false)
        .limit(1);

    if (res.isEmpty) return '—';

    final date = DateTime.parse(res.first['created_at']);
    return 'Update: ${DateFormat('dd MMM yyyy').format(date)}';
  }

  // إجمالي التبرعات
  Future<int> getTotalDonations() async {
    final res = await supabase.from('user_items').select('id');

    return res.length;
  }

  /////////////////////////
  Future<String> getLastDonationsUpdate() async {
    final List res = await supabase
        .from('user_items')
        .select('created_at')
        .order('created_at', ascending: false)
        .limit(1);

    if (res.isEmpty) return '—';

    final date = DateTime.parse(res.first['created_at']);
    return 'Update: ${DateFormat('dd MMM yyyy').format(date)}';
  }

  // عدد الطلبات حسب الحالة
  Future<int> getRequests() async {
    final res = await supabase.from('requests').select('id');

    return res.length;
  }

  /////////////////////////////////////////
  Future<String> getLastRequestUpdate() async {
    final List res = await supabase
        .from('requests')
        .select('created_at')
        .order('created_at', ascending: false)
        .limit(1);

    if (res.isEmpty) return '—';

    final date = DateTime.parse(res.first['created_at']);
    return 'Update: ${DateFormat('dd MMM yyyy').format(date)}';
  }

  // الحالات المتأخرة
  Future<int> getLateRequests() async {
    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String();

    final List res = await supabase
        .from('requests')
        .select('id')
        .lt('created_at', sevenDaysAgo)
        .neq('status', 'pending');

    return res.length;
  }
}

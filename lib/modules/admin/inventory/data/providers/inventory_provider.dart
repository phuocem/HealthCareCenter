import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchItems() async {
    
    return await _supabase.from('inventory_items').select('*, inventory_batches(*)');
  }

  Future<void> addItem(Map<String, dynamic> data) async {
    await _supabase.from('inventory_items').insert(data);
  }

  Future<void> addBatch(Map<String, dynamic> data) async {
    await _supabase.from('inventory_batches').insert(data);
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    return await _supabase.from('stock_transactions').select('*, inventory_items(name)').order('created_at', ascending: false);
  }
}

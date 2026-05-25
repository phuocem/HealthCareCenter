import '../providers/inventory_provider.dart';

class InventoryRepository {
  final InventoryProvider _provider = InventoryProvider();

  Future<List<Map<String, dynamic>>> getInventory() async {
    return await _provider.fetchItems();
  }

  Future<void> addInventoryItem(Map<String, dynamic> data) async {
    return await _provider.addItem(data);
  }

  Future<List<Map<String, dynamic>>> getRecentTransactions() async {
    return await _provider.fetchTransactions();
  }
}

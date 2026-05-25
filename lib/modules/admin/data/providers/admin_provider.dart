import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProvider {
  final _supabase = Supabase.instance.client;

  
  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    return await _supabase.from('departments').select().order('name');
  }

  Future<void> createDepartment(Map<String, dynamic> data) async {
    await _supabase.from('departments').insert(data);
  }

  Future<void> updateDepartment(String id, Map<String, dynamic> data) async {
    await _supabase.from('departments').update(data).eq('id', id);
  }

  Future<void> deleteDepartment(String id) async {
    await _supabase.from('departments').delete().eq('id', id);
  }

  
  Future<List<Map<String, dynamic>>> fetchServices() async {
    return await _supabase.from('services').select('*, departments(name)').order('name');
  }

  Future<void> createService(Map<String, dynamic> data) async {
    await _supabase.from('services').insert(data);
  }

  Future<void> updateService(String id, Map<String, dynamic> data) async {
    await _supabase.from('services').update(data).eq('id', id);
  }

  Future<void> deleteService(String id) async {
    await _supabase.from('services').delete().eq('id', id);
  }

  
  Future<List<Map<String, dynamic>>> fetchLabTestTypes() async {
    return await _supabase.from('lab_test_types').select('*, services(name)').order('test_name');
  }

  Future<void> createLabTestType(Map<String, dynamic> data) async {
    await _supabase.from('lab_test_types').insert(data);
  }

  Future<void> updateLabTestType(String id, Map<String, dynamic> data) async {
    await _supabase.from('lab_test_types').update(data).eq('id', id);
  }

  Future<void> deleteLabTestType(String id) async {
    await _supabase.from('lab_test_types').delete().eq('id', id);
  }

  
  Future<List<Map<String, dynamic>>> fetchInventoryItems() async {
    return await _supabase.from('inventory_items').select().order('name');
  }

  
  Future<List<Map<String, dynamic>>> fetchSuppliers() async {
    return await _supabase.from('suppliers').select().order('name');
  }
}

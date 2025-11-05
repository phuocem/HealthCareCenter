// src/screens/patient/BookByDoctor/BookByDoctor.js
import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, FlatList, TextInput } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import Animated, { FadeInDown } from 'react-native-reanimated';

const Colors = {
  primary: '#1D4ED8',
  secondary: '#38BDF8',
  textPrimary: '#1E293B',
  textSecondary: '#4B5563',
  bg: '#F8FAFC',
};

const doctors = [
  { id: 1, name: 'TS BS. Phan Huỳnh An', gender: 'Nam', dept: 'Phẫu thuật Hàm Mặt - RHM', price: '150.000đ', slots: ['Sáng thứ 4', 'Sáng thứ 6'] },
  { id: 2, name: 'ThS BS. Lê Thụy Minh An', gender: 'Nữ', dept: 'Thần kinh', price: '150.000đ', slots: ['Chiều thứ 5'] },
];

export default function BookByDoctor() {
  const navigation = useNavigation();
  const [search, setSearch] = useState('');

  const filtered = doctors.filter(d => d.name.toLowerCase().includes(search.toLowerCase()));

  const handleSelect = (doctor) => {
    navigation.navigate('SelectDate', { doctor });
  };

  const renderItem = ({ item }) => (
    <TouchableOpacity style={styles.card} onPress={() => handleSelect(item)}>
      <View style={styles.header}>
        <View style={styles.avatar}>
          <Ionicons name="person" size={32} color="#FFF" />
        </View>
        <View>
          <Text style={styles.name}>{item.name}</Text>
          <Text style={styles.gender}>Giới tính: {item.gender}</Text>
        </View>
      </View>
      <Text style={styles.dept}>{item.dept}</Text>
      <Text style={styles.price}>{item.price}</Text>
      <View style={styles.slots}>
        {item.slots.map(s => <Text key={s} style={styles.slot}>{s}</Text>)}
        <TouchableOpacity style={styles.btn}>
          <Text style={styles.btnText}>Chọn</Text>
        </TouchableOpacity>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <Animated.View entering={FadeInDown.duration(400)} style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={26} color={Colors.primary} />
        </TouchableOpacity>
        <Text style={styles.title}>Chọn bác sĩ</Text>
        <TouchableOpacity onPress={() => navigation.navigate('Home')}>
          <Ionicons name="home" size={24} color={Colors.primary} />
        </TouchableOpacity>
      </Animated.View>

      <View style={styles.search}>
        <Ionicons name="search" size={20} color={Colors.textSecondary} />
        <TextInput
          placeholder="Tìm kiếm bác sĩ..."
          value={search}
          onChangeText={setSearch}
          style={styles.input}
        />
      </View>

      <FlatList
        data={filtered}
        renderItem={renderItem}
        keyExtractor={item => item.id.toString()}
        contentContainerStyle={styles.list}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.bg },
  header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16 },
  title: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  search: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#FFF', margin: 16, paddingHorizontal: 12, borderRadius: 12, borderWidth: 1, borderColor: '#E5E7EB' },
  input: { flex: 1, marginLeft: 8, fontSize: 16 },
  list: { paddingHorizontal: 16 },
  card: { backgroundColor: '#FFF', padding: 16, borderRadius: 16, marginBottom: 12, borderWidth: 1, borderColor: '#E5E7EB' },
  header: { flexDirection: 'row', marginBottom: 12 },
  avatar: { width: 56, height: 56, borderRadius: 28, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center', marginRight: 12 },
  name: { fontSize: 16, fontWeight: '700', color: Colors.textPrimary },
  gender: { fontSize: 13, color: Colors.textSecondary },
  dept: { fontSize: 15, fontWeight: '600', marginBottom: 4 },
  price: { fontSize: 16, fontWeight: '700', color: Colors.primary, marginBottom: 8 },
  slots: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  slot: { fontSize: 14, color: '#10B981' },
  btn: { backgroundColor: Colors.primary, paddingHorizontal: 16, paddingVertical: 6, borderRadius: 8 },
  btnText: { color: '#FFF', fontWeight: '600' },
});
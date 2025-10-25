import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import AdminHomeScreen from '../screens/admin/AdminHomeScreen';
import ManageDoctorsScreen from '../screens/admin/ManageDoctorsScreen';
import ManageUsersScreen from '../screens/admin/ManageUsersScreen';

const Tab = createBottomTabNavigator();

export default function AdminTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Trang chủ" component={AdminHomeScreen} />
      <Tab.Screen name="Bác sĩ" component={ManageDoctorsScreen} />
      <Tab.Screen name="Người dùng" component={ManageUsersScreen} />
    </Tab.Navigator>
  );
}

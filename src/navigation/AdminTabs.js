import React from 'react';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../shared/colors';

import AdminHomeScreen from '../screens/admin/AdminHomeScreen';
import ManageDoctorsScreen from '../screens/admin/ManageDoctorsScreen';
import ManageUsersScreen from '../screens/admin/ManageUsersScreen';
import ManagePatientsScreen from '../screens/admin/ManagePatientsScreen';
import AdminDashboard from '../screens/admin/AdminDashboard';
import CreateUserScreen from '../screens/admin/CreateUserScreen';
import ReportsScreen from '../screens/admin/ReportsScreen';
import CreateStaffAccountScreen from '../screens/admin/CreateStaffAccountScreen';
import CreateDoctorAccountScreen from '../screens/admin/CreateDoctorAccountScreen';

const Drawer = createDrawerNavigator();

export default function AdminTabs() {
  return (
    <Drawer.Navigator
      initialRouteName="Trang chủ"
      screenOptions={({ route }) => ({
        headerShown: true,
        headerTintColor: Colors.white,
        headerStyle: { backgroundColor: Colors.primary },
        drawerActiveTintColor: Colors.primary,
        drawerInactiveTintColor: Colors.textSecondary,
        drawerStyle: {
          backgroundColor: Colors.card,
          width: 250,
        },
        drawerIcon: ({ color, size }) => {
          const icons = {
            'Trang chủ': 'home-outline',
            'Bác sĩ': 'medkit-outline',
            'Bệnh nhân': 'heart-outline',
            'Người dùng': 'people-outline',
            'Quản trị': 'settings-outline',
            'Tạo tài khoản': 'person-add-outline',
            'Tạo bác sĩ': 'briefcase-outline',
            'Báo cáo': 'bar-chart-outline',
          };
          return <Ionicons name={icons[route.name] || 'ellipse-outline'} size={size} color={color} />;
        },
      })}
    >
      <Drawer.Screen name="Trang chủ" component={AdminHomeScreen} />
      <Drawer.Screen name="Bác sĩ" component={ManageDoctorsScreen} />
      <Drawer.Screen name="Bệnh nhân" component={ManagePatientsScreen} />
      <Drawer.Screen name="Người dùng" component={ManageUsersScreen} />
      <Drawer.Screen name="Quản trị" component={AdminDashboard} />
      <Drawer.Screen name="Tạo tài khoản" component={CreateUserScreen} />
      <Drawer.Screen name="Tạo bác sĩ" component={CreateDoctorAccountScreen} />
      <Drawer.Screen name="Báo cáo" component={ReportsScreen} />
    </Drawer.Navigator>
  );
}

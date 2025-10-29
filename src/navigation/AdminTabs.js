import React from 'react';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../shared/colors';

// 📁 Import các màn hình
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

export default function AdminDrawer() {
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
          let iconName;

          switch (route.name) {
            case 'Trang chủ':
              iconName = 'home-outline';
              break;
            case 'Bác sĩ':
              iconName = 'medkit-outline';
              break;
            case 'Bệnh nhân':
              iconName = 'heart-outline';
              break;
            case 'Người dùng':
              iconName = 'people-outline';
              break;
            case 'Quản trị':
              iconName = 'settings-outline';
              break;
            case 'Tạo tài khoản':
              iconName = 'person-add-outline';
              break;
            case 'Tạo nhân viên':
              iconName = 'briefcase-outline';
              break;
            case 'Báo cáo':
              iconName = 'bar-chart-outline';
              break;
            default:
              iconName = 'ellipse-outline';
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
      })}
    >
      <Drawer.Screen name="Trang chủ" component={AdminHomeScreen} />
      <Drawer.Screen name="Bác sĩ" component={ManageDoctorsScreen} />
      <Drawer.Screen name="Bệnh nhân" component={ManagePatientsScreen} />
      <Drawer.Screen name="Người dùng" component={ManageUsersScreen} />
      <Drawer.Screen name="Quản trị" component={AdminDashboard} />
      <Drawer.Screen name="Tạo tài khoản" component={CreateUserScreen} />
      <Drawer.Screen name="Tạo nhân viên" component={CreateDoctorAccountScreen} />
      <Drawer.Screen name="Báo cáo" component={ReportsScreen} />
    </Drawer.Navigator>
  );
}

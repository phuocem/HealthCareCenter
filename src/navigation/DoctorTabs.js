import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import DoctorHomeScreen from '../screens/doctor/DoctorHomeScreen';
import DoctorAppointmentsScreen from '../screens/doctor/DoctorAppointmentsScreen';
import ProfileScreen from '../screens/doctor/ProfileScreen';


const Tab = createBottomTabNavigator();

export default function DoctorTabs() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Trang chủ" component={DoctorHomeScreen} />
      <Tab.Screen name="Lịch hẹn" component={DoctorAppointmentsScreen} />
      <Tab.Screen name="Hồ sơ" component={ProfileScreen} />
    </Tab.Navigator>
  );
}

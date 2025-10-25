// src/navigation/PatientTabs.js
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import HomeScreen from '../screens/patient/HomeScreen';
import AppointmentScreen from '../screens/patient/AppointmentScreen';
import HistoryScreen from '../screens/patient/HistoryScreen';
import ProfileScreen from '../screens/patient/ProfileScreen';

const Tab = createBottomTabNavigator();

export default function PatientTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Trang chủ" component={HomeScreen} />
      <Tab.Screen name="Lịch khám" component={AppointmentScreen} />
      <Tab.Screen name="Lịch sử" component={HistoryScreen} />
      <Tab.Screen name="Hồ sơ" component={ProfileScreen} />
    </Tab.Navigator>
  );
}

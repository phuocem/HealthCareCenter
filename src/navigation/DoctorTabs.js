import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import DoctorHomeScreen from '../screens/doctor/DoctorHomeScreen';
import ScheduleScreen from '../screens/doctor/ScheduleScreen';
import ProfileScreen from '../screens/doctor/ProfileScreen';


const Tab = createBottomTabNavigator();

export default function DoctorTabs() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Trang chủ" component={DoctorHomeScreen} />
      <Tab.Screen name="Lịch làm việc" component={ScheduleScreen} />
      <Tab.Screen name="Hồ sơ" component={ProfileScreen} />
    </Tab.Navigator>
  );
}

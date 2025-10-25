import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import DoctorHomeScreen from '../screens/doctors/DoctorHomeScreen';
import ScheduleScreen from '../screens/doctors/ScheduleScreen';
import ProfileScreen from '../screens/doctors/ProfileScreen';


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

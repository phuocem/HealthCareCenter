import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import ReceptionHomeScreen from '../screens/receptionist/ReceptionHomeScreen.js';
import AppointmentQueueScreen from '../screens/receptionist/AppointmentQueueScreen';
import PatientCheckinScreen from '../screens/receptionist/PatientCheckinScreen';

const Tab = createBottomTabNavigator();

export default function ReceptionTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Trang chủ" component={ReceptionHomeScreen} />
      <Tab.Screen name="Hàng đợi khám" component={AppointmentQueueScreen} />
      <Tab.Screen name="Check-in bệnh nhân" component={PatientCheckinScreen} />
    </Tab.Navigator>
  );
}

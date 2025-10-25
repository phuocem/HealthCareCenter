import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import AccountantHomeScreen from '../screens/accountant/AccountantHomeScreen';
import BillingScreen from '../screens/accountant/BillingScreen';
import ReportScreen from '../screens/accountant/ReportScreen';

const Tab = createBottomTabNavigator();

export default function AccountantTabs() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="Trang chủ" component={AccountantHomeScreen} />
      <Tab.Screen name="Hóa đơn" component={BillingScreen} />
      <Tab.Screen name="Báo cáo" component={ReportScreen} />
    </Tab.Navigator>
  );
}

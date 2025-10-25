import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import AuthNavigator from './AuthNavigator';
import RoleRedirect from '../screens/auth/RoleRedirect';
import AdminTabs from './AdminTabs';
import DoctorTabs from './DoctorTabs';
import PatientTabs from './PatientTabs';
import ReceptionTabs from './ReceptionTabs';
import AccountantTabs from './AccountantTabs';

const Stack = createStackNavigator();

export default function RootNavigator() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="Auth" component={AuthNavigator} />
      <Stack.Screen name="RoleRedirect" component={RoleRedirect} />
      <Stack.Screen name="AdminTabs" component={AdminTabs} />
      <Stack.Screen name="DoctorTabs" component={DoctorTabs} />
      <Stack.Screen name="PatientTabs" component={PatientTabs} />
      <Stack.Screen name="ReceptionTabs" component={ReceptionTabs} />
      <Stack.Screen name="AccountantTabs" component={AccountantTabs} />
    </Stack.Navigator>
  );
}

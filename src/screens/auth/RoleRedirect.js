// src/screens/auth/RoleRedirect.js
import React, { useEffect } from 'react';
import { ActivityIndicator, View } from 'react-native';
import { getUserProfile } from '../../controllers/authController';
import { useNavigation } from '@react-navigation/native';
import { supabase } from '../../api/supabase';

export default function RoleRedirect() {
  const navigation = useNavigation();

  useEffect(() => {
    const checkRole = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        navigation.replace('Login');
        return;
      }

      try {
        const profile = await getUserProfile(user.id);
        switch (profile.role) {
          case 'doctor':
            navigation.replace('DoctorTabs');
            break;
          case 'admin':
            navigation.replace('AdminTabs');
            break;
          case 'receptionist':
            navigation.replace('ReceptionTabs');
            break;
          case 'accountant':
            navigation.replace('AccountantTabs');
            break;
          default:
            navigation.replace('MainTabs'); // patient
        }
      } catch (err) {
        console.error(err);
        navigation.replace('Login');
      }
    };
    checkRole();
  }, []);

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <ActivityIndicator size="large" color="#007BFF" />
    </View>
  );
}

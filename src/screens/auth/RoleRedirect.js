import React, { useEffect } from 'react';
import { View, ActivityIndicator } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { supabase } from '../../api/supabase';

export default function RoleRedirect() {
  const navigation = useNavigation();

  useEffect(() => {
    const checkRole = async () => {
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError || !user) {
        navigation.replace('Auth');
        return;
      }

      const { data: profile, error: profileError } = await supabase
        .from('user_profiles')
        .select('role_id, roles(name)')
        .eq('id', user.id)
        .single();

      if (profileError || !profile) {
        navigation.replace('Auth');
        return;
      }

      const role = profile.roles?.name || 'patient';

      switch (role) {
        case 'admin':
          navigation.replace('AdminTabs');
          break;
        case 'doctor':
          navigation.replace('DoctorTabs');
          break;
        case 'patient':
          navigation.replace('PatientTabs');
          break;
        case 'receptionist':
          navigation.replace('ReceptionTabs');
          break;
        case 'accountant':
          navigation.replace('AccountantTabs');
          break;
        default:
          navigation.replace('PatientTabs');
          break;
      }
    };

    checkRole();
  }, [navigation]);

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <ActivityIndicator size="large" color="#007AFF" />
    </View>
  );
}

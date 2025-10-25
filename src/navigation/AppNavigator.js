import React, { useEffect, useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { supabase } from '../api/supabase';
import AuthStack from './AuthNavigator';
import MainTabs from './MainTabs';
import DoctorTabs from './DoctorTabs';
import AdminTabs from './AdminTabs';
import { getUserRole } from '../controllers/userController';

export default function AppNavigator() {
  const [role, setRole] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const roleName = await getUserRole(user.id);
        setRole(roleName);
      }
      setLoading(false);
    };
    load();
  }, []);

  if (loading) return null;

  return (
    <NavigationContainer>
      {!role && <AuthStack />}
      {role === 'patient' && <MainTabs />}
      {role === 'doctor' && <DoctorTabs />}
      {role === 'admin' && <AdminTabs />}
    </NavigationContainer>
  );
}

import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, Image, useWindowDimensions, Platform } from 'react-native';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';
import Animated, { FadeIn } from 'react-native-reanimated';
import { supabase } from '../api/supabase';
import { patientDrawerStyles as styles } from '../styles/patient/patientDrawerStyles';

import HomeScreen from '../screens/patient/HomeScreen';
import AppointmentScreen from '../screens/patient/AppointmentScreen';
import HistoryScreen from '../screens/patient/HistoryScreen';
import ProfileScreen from '../screens/patient/ProfileScreen';

const Drawer = createDrawerNavigator();

function CustomDrawerContent({ navigation }) {
  const [profile, setProfile] = useState(null);
  const { width } = useWindowDimensions();
  const drawerWidth = Math.min(width * 0.75, 320);

   useEffect(() => {
    const fetchProfile = async () => {
      try {
        const { data: { user } } = await supabase.auth.getUser();
        if (user) {
          const userProfile = await getUserProfile(user.id);
          setProfile(userProfile);
        }
      } catch (error) {
        console.error('❌ Lỗi khi tải hồ sơ:', error);
      }
    };
    fetchProfile();
  }, []);

  const menuItems = [
    { name: 'Trang chủ', icon: 'home-outline', screen: 'HomeScreen' },
    { name: 'Lịch khám', icon: 'calendar-outline', screen: 'AppointmentScreen' },
    { name: 'Lịch sử khám', icon: 'time-outline', screen: 'HistoryScreen' },
    { name: 'Hồ sơ cá nhân', icon: 'person-outline', screen: 'ProfileScreen' },
  ];

  return (
    <LinearGradient
      colors={['#007AFF', '#6BCBFF']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[styles.drawerContainer, { width: drawerWidth }]}
    >
      <BlurView intensity={70} tint="light" style={styles.headerContainer}>
        <View style={styles.avatarWrapper}>
          <LinearGradient colors={['#00C6FF', '#007AFF']} style={styles.avatarBorder}>
            <Image source={{ uri: 'https://i.pravatar.cc/150?img=68' }} style={styles.avatar} />
          </LinearGradient>
        </View>
        <Text style={styles.userName}>{profile ? profile.full_name : 'Đang tải...'}</Text>
        <Text style={styles.userEmail}>{profile ? profile.email : ''}</Text>
      </BlurView>

      <View style={styles.menuContainer}>
        {menuItems.map((item, index) => (
          <Animated.View key={item.name} entering={FadeIn.delay(100 * index).duration(400)}>
            <TouchableOpacity
              onPress={() => navigation.navigate(item.screen)}
              activeOpacity={0.85}
              style={styles.menuItem}
            >
              <View style={styles.iconWrapper}>
                <Ionicons name={item.icon} size={24} color="#fff" />
              </View>
              <Text style={styles.menuText}>{item.name}</Text>
              <Ionicons
                name="chevron-forward-outline"
                size={20}
                color="#fff"
                style={{ opacity: 0.7, marginLeft: 'auto' }}
              />
            </TouchableOpacity>
          </Animated.View>
        ))}
      </View>

      <View style={styles.footer}>
        <TouchableOpacity
          activeOpacity={0.9}
          style={styles.logoutButton}
          onPress={async () => {
            const { error } = await supabase.auth.signOut();
            if (!error) {
              navigation.reset({
                index: 0,
                routes: [{ name: 'Auth', state: { routes: [{ name: 'Login' }] } }],
              });
            }
          }}
        >
          <LinearGradient
            colors={['#FF6B6B', '#FF4757']}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
            style={styles.logoutGradient}
          >
            <Ionicons name="log-out-outline" size={22} color="#fff" />
            <Text style={styles.logoutText}>Đăng xuất</Text>
          </LinearGradient>
        </TouchableOpacity>

        <Text style={styles.versionText}>Phiên bản 1.0.0</Text>
      </View>
    </LinearGradient>
  );
}

export default function PatientDrawer() {
  const { width } = useWindowDimensions();
  const drawerWidth = Math.min(width * 0.75, 320);

  return (
    <Drawer.Navigator
      drawerContent={(props) => <CustomDrawerContent {...props} />}
      screenOptions={({ navigation }) => ({
        headerStyle: {
          backgroundColor: '#007AFF',
          height: Platform.OS === 'ios' ? 100 : 80,
        },
        headerTintColor: '#fff',
        headerTitleAlign: 'center',
        headerTitleStyle: { fontWeight: '700', fontSize: 20 },
        drawerType: 'front',
        overlayColor: 'transparent',
        drawerStyle: {
          width: drawerWidth,
          backgroundColor: 'transparent',
          marginTop: Platform.OS === 'ios' ? 100 : 80,
        },
        headerLeft: () => (
          <TouchableOpacity style={{ marginLeft: 16 }} onPress={() => navigation.openDrawer()}>
            <Ionicons name="menu-outline" size={28} color="#fff" />
          </TouchableOpacity>
        ),
      })}
    >
      <Drawer.Screen name="HomeScreen" component={HomeScreen} options={{ title: 'Trang chủ' }} />
      <Drawer.Screen name="AppointmentScreen" component={AppointmentScreen} options={{ title: 'Lịch khám' }} />
      <Drawer.Screen name="HistoryScreen" component={HistoryScreen} options={{ title: 'Lịch sử khám' }} />
      <Drawer.Screen name="ProfileScreen" component={ProfileScreen} options={{ title: 'Hồ sơ cá nhân' }} />
    </Drawer.Navigator>
  );
}

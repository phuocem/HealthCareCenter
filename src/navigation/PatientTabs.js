import React from 'react';
import { createDrawerNavigator } from '@react-navigation/drawer';
import { createStackNavigator } from '@react-navigation/stack';
import { Ionicons } from '@expo/vector-icons';
import {
  useWindowDimensions,
  TouchableOpacity,
  View,
  Text,
  Image,
  StyleSheet,
  Platform,
} from 'react-native';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';

import HomeScreen from '../screens/patient/HomeScreen';
import AppointmentScreen from '../screens/patient/AppointmentScreen';
import HistoryScreen from '../screens/patient/HistoryScreen';
import ProfileScreen from '../screens/patient/ProfileScreen';

const Drawer = createDrawerNavigator();
const Stack = createStackNavigator();

function CustomDrawerContent({ navigation }) {
  const { width } = useWindowDimensions();
  const drawerWidth = Math.min(width * 0.78, 340);

  const menuItems = [
    { name: 'Trang chủ', icon: 'home-outline', screen: 'HomeScreen' },
    { name: 'Lịch khám', icon: 'calendar-outline', screen: 'AppointmentScreen' },
    { name: 'Lịch sử khám', icon: 'time-outline', screen: 'HistoryScreen' },
    { name: 'Hồ sơ cá nhân', icon: 'person-outline', screen: 'ProfileScreen' },
  ];

  return (
    <LinearGradient
      colors={['#007AFF', '#00C6FF']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[styles.drawerContainer, { width: drawerWidth }]}
    >
      <BlurView intensity={50} tint="light" style={styles.headerContainer}>
        <Image
          source={{ uri: 'https://i.pravatar.cc/150?img=68' }}
          style={styles.avatar}
        />
        <Text style={styles.userName}>Nguyễn Văn A</Text>
        <Text style={styles.userEmail}>patient@example.com</Text>
      </BlurView>

      <View style={styles.menuContainer}>
        {menuItems.map((item, index) => (
          <Animated.View
            key={item.name}
            entering={FadeIn.delay(120 * index).duration(400)}
            exiting={FadeOut}
          >
            <TouchableOpacity
              onPress={() => navigation.navigate(item.screen)}
              activeOpacity={0.7}
              style={styles.menuItem}
            >
              <View style={styles.iconWrapper}>
                <Ionicons name={item.icon} size={24} color="#fff" />
              </View>
              <Text style={styles.menuText}>{item.name}</Text>
            </TouchableOpacity>
          </Animated.View>
        ))}
      </View>

      <View style={styles.footer}>
        <TouchableOpacity
          activeOpacity={0.8}
          style={styles.logoutButton}
          onPress={() => console.log('Đăng xuất')}
        >
          <Ionicons name="log-out-outline" size={22} color="#fff" />
          <Text style={styles.logoutText}>Đăng xuất</Text>
        </TouchableOpacity>
        <Text style={styles.versionText}>Phiên bản 1.0.0</Text>
      </View>
    </LinearGradient>
  );
}

function DrawerContent() {
  const { width } = useWindowDimensions();
  const drawerWidth = Math.min(width * 0.78, 340);

  return (
    <Drawer.Navigator
      drawerContent={(props) => <CustomDrawerContent {...props} />}
      screenOptions={{
        headerShown: false,
        drawerType: 'front',
        overlayColor: 'rgba(0,0,0,0.2)',
        drawerStyle: {
          width: drawerWidth,
          backgroundColor: 'transparent',
        },
        sceneContainerStyle: {
          backgroundColor: '#F9FAFB',
          borderRadius: 24,
          overflow: 'hidden',
        },
        swipeEdgeWidth: 70,
      }}
    >
      <Drawer.Screen name="HomeScreen" component={HomeScreen} />
      <Drawer.Screen name="AppointmentScreen" component={AppointmentScreen} />
      <Drawer.Screen name="HistoryScreen" component={HistoryScreen} />
      <Drawer.Screen name="ProfileScreen" component={ProfileScreen} />
    </Drawer.Navigator>
  );
}

export default function PatientDrawer() {
  return (
    <Stack.Navigator
      screenOptions={({ navigation }) => ({
        headerStyle: {
          backgroundColor: '#007AFF',
          elevation: 0,
          shadowOpacity: 0,
        },
        headerTintColor: '#fff',
        headerTitleAlign: 'center',
        headerTitleStyle: {
          fontWeight: '700',
          fontSize: 20,
        },
        headerLeft: () => (
          <TouchableOpacity
            style={{ marginLeft: 16 }}
            onPress={() => navigation.openDrawer()}
          >
            <Ionicons name="menu-outline" size={28} color="#fff" />
          </TouchableOpacity>
        ),
      })}
    >
      <Stack.Screen
        name="MainDrawer"
        component={DrawerContent}
        options={{
          title: 'Ứng dụng Bệnh nhân',
        }}
      />
    </Stack.Navigator>
  );
}

const styles = StyleSheet.create({
  drawerContainer: {
    flex: 1,
    paddingTop: Platform.OS === 'ios' ? 60 : 50,
    borderTopRightRadius: 32,
    borderBottomRightRadius: 32,
    overflow: 'hidden',
  },
  headerContainer: {
    alignItems: 'center',
    paddingVertical: 24,
    marginHorizontal: 16,
    borderRadius: 20,
    backgroundColor: 'rgba(255,255,255,0.15)',
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 50,
    borderWidth: 2.5,
    borderColor: '#fff',
    marginBottom: 12,
  },
  userName: {
    color: '#fff',
    fontSize: 18,
    fontWeight: '700',
  },
  userEmail: {
    color: '#E6F0FF',
    fontSize: 14,
    opacity: 0.9,
  },
  menuContainer: {
    flex: 1,
    marginTop: 20,
    paddingHorizontal: 12,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius: 16,
    paddingVertical: 14,
    paddingHorizontal: 16,
    marginBottom: 8,
  },
  iconWrapper: {
    width: 32,
    alignItems: 'center',
    justifyContent: 'center',
  },
  menuText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '500',
    marginLeft: 8,
  },
  footer: {
    padding: 16,
    borderTopWidth: 0.3,
    borderTopColor: 'rgba(255,255,255,0.3)',
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 8,
  },
  logoutText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '500',
  },
  versionText: {
    color: '#E6F0FF',
    fontSize: 13,
    opacity: 0.8,
    textAlign: 'center',
  },
});

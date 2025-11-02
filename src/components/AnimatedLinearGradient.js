// src/components/AnimatedLinearGradient.js
import Animated, { useAnimatedProps } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';

const AnimatedLG = Animated.createAnimatedComponent(LinearGradient);

export default function AnimatedLinearGradient({ colors = [], animatedColors, ...props }) {
  const animatedProps = useAnimatedProps(() => ({
    colors: animatedColors || colors,
  }), [animatedColors, colors]);

  return <AnimatedLG {...props} animatedProps={animatedProps} />;
}
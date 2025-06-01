import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ATthemeSwitch extends StatefulWidget {
  const ATthemeSwitch({super.key});

  @override
  State<ATthemeSwitch> createState() => _ATthemeSwitchState();
}

class _ATthemeSwitchState extends State<ATthemeSwitch> {
  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<int>.rolling(
      height: 40,
      borderWidth: 1,
      animationCurve: Curves.decelerate,
      spacing: 0.1,
      style: ToggleStyle(borderRadius: BorderRadius.circular(10)),
        current: context.watch<ThemeProvider>().getValue,
        values: const [0, 1],
        onChanged: (i) {
          context.read<ThemeProvider>().toggleTheme(i);
        },
        iconList: const [
          Icon(Icons.light_mode),
          Icon(Icons.dark_mode),
        ],
        // iconList: [...], you can use iconBuilder, customIconBuilder or iconList
      );
  }
}

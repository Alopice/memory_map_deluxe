import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class ATnotifSwitch extends StatefulWidget {
  const ATnotifSwitch({super.key});

  @override
  State<ATnotifSwitch> createState() => _ATnotifSwitchState();
}

class _ATnotifSwitchState extends State<ATnotifSwitch> {
  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<int>.rolling(
      height: 40,
      borderWidth: 1,
      animationCurve: Curves.decelerate,
      spacing: 0.1,
      style: ToggleStyle(borderRadius: BorderRadius.circular(10)),
        current: context.watch<NotificationProvider>().getValue,
        values: const [0, 1],
        onChanged: (i) {
          context.read<NotificationProvider>().toggleNotification(i);
        },
        iconList: const [
          Icon(Icons.notifications_active_sharp),
          Icon(Icons.notifications_off),
        ],
        // iconList: [...], you can use iconBuilder, customIconBuilder or iconList
      );
  }
}

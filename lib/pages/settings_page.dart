import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_map/utils/about_button.dart';
import 'package:memory_map/utils/at_switch_notif.dart';
import 'package:memory_map/utils/at_switch_theme.dart';
import 'package:memory_map/utils/logout_button.dart';
import 'package:memory_map/utils/settings_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int value = 0;
  String discordLink = "https://discord.gg/xcmtrhJC";

  Future<void> _joinDiscord() async {
    final Uri url = Uri.parse(discordLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open Discord invite link.");
    }
  }
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
  
      body: 
            
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: WidgetCircularAnimator(
                  innerColor: Colors.indigoAccent,
                  outerColor: Colors.black,
                            child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[200]),
                  child: Image.network(user!.photoURL!, fit: BoxFit.cover,),
                ),
                            ),
                        ),
              ),
              
              
              //change theme
              SettingsTile(addingWidget: ATthemeSwitch(),topText: "Theme", bottomText: "Theme",),
              //toggle notification
              SettingsTile(addingWidget: ATnotifSwitch(),topText: "Notification", bottomText: "Notification",),
              //logout
              SettingsTile(addingWidget: LogoutButton(),topText: "Account", bottomText: "Logout",),
              //about 
              SettingsTile(addingWidget: AboutButton(),topText: "About", bottomText: "About app",),
              GestureDetector(
                onTap: _joinDiscord,
                child: Icon(Icons.discord, size: 30,)),
              Text("AR Memory Map v1.0.0", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),),
            ],

          ),
        
      
    );
  }
}

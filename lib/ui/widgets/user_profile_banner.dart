import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/services/auth_utility.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';
import '../screens/update_profile_screen.dart';

class UserProfileBanner extends StatefulWidget {
  final bool? isUpdateScreen;

  const UserProfileBanner({super.key, this.isUpdateScreen});

  @override
  State<UserProfileBanner> createState() => _UserProfileBannerState();
}

class _UserProfileBannerState extends State<UserProfileBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: ListTile(
          onTap: () {
            if ((widget.isUpdateScreen ?? false) == false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()));
            }
          },
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          //tileColor: Colors.blue,

          //enabled: true,
          leading: CircleAvatar(
            radius: 15,
            child: CachedNetworkImage(
              imageUrl: AuthUtility.userinfo.data?.photo ?? "",
              placeholder: (_, __) =>
                  Image.asset("assets/images/user_image.jpg"),
              errorWidget: (_, __, ___) =>
                  Image.asset("assets/images/user_image.jpg"),
            ),
          ),
          title: Text(
            "${AuthUtility.userinfo.data?.firstName ?? ""} ${AuthUtility.userinfo.data?.lastName ?? ""}",
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "${AuthUtility.userinfo.data?.email}",
            style: const TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            onPressed: () async {
              await AuthUtility.clearUserInfo();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              }
            },
            icon: const Icon(Icons.logout),
          )),
    );
  }
}

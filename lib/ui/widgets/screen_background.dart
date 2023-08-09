import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager_app/ui/utils/assets_utils.dart';

class ScreenBackground extends StatelessWidget {

  final Widget child;
  const ScreenBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SvgPicture.asset(
            AssetsUtils.bgSVG,
            fit: BoxFit.fill,
          ),
        ),
        SafeArea(child: child)
      ],

    );
  }
}
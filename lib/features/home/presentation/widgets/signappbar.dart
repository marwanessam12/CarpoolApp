import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignAppbar extends StatelessWidget {
  const SignAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuary = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('عربي'),
              SizedBox(
                width: mediaQuary.width * 0.02,
              ),
              SvgPicture.asset(
                'assets/icons/world.svg',
                height: mediaQuary.width * 0.05,
                width: mediaQuary.width * 0.05,
              ),
            ],
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerificationCode extends StatelessWidget {
  const VerificationCode({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Pinput(
        length: 6,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,

      ),
    );

  }
}

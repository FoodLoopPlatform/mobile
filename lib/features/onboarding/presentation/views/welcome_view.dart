import 'package:flutter/material.dart';
import 'package:foodloop/features/onboarding/presentation/views/widgets/welcome_body.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeBody(),
    );
  }
}

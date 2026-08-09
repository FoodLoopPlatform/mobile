import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_cubit.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_state.dart';
import 'package:foodloop/features/onboarding/presentation/views/widgets/welcome_body.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, _) => Scaffold(body: WelcomeBody()),
    );
  }
}

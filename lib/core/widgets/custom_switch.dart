import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

/// A pill-style toggle switch matching the Foodloop design system.
///
/// Holds its own visual on/off state so it can flip locally without any
/// external state management. Pass [value] for the initial position and
/// listen via [onChanged] when the real toggle logic is wired up later.
class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    this.value = false,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  void _toggle() {
    setState(() => _isOn = !_isOn);
    widget.onChanged?.call(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        width: 46.w,
        height: 26.h,
        padding: EdgeInsets.all(3.r),
        decoration: BoxDecoration(
          color:
              _isOn ? AppColors.primaryLight : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
        ),
        child: AnimatedAlign(
          duration: AppConstants.animationFast,
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.r,
            height: 20.r,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

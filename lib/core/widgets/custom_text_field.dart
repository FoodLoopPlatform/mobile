import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.isPassword = false,
    this.enabled = true,
    this.maxLines = 1,
    this.suffixWidget,
  });

  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  bool isPassword;
  final bool enabled;
  final int maxLines;
  final Widget? suffixWidget;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          obscureText: widget.isPassword && _obscureText,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                    size: 18.r, color: AppColors.neutralLight)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18.r,
                      color: AppColors.neutralLight,
                    ),
                  )
                : widget.suffixWidget,
          ),
        ),
      ],
    );
  }
}

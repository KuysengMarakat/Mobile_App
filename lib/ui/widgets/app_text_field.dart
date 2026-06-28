import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Reusable styled text field widget.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixWidget,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppTheme.primaryPurple)
            : null,
        suffixIcon: suffixWidget,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }
}

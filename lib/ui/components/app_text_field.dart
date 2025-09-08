import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.style,
    this.decoration,
    this.suffixText,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.errorText,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
  });
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final bool enabled;
  final bool readOnly;
  final TextStyle? style;
  final InputDecoration? decoration;
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final String? errorText;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: readOnly
            ? null
            : Border.all(
                color: theme.colorScheme.primaryContainer,
                width: 0.5,
              ),
        gradient: ClonesColors.gradientInputFormBackground,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        enabled: enabled,
        readOnly: readOnly,
        style: style ?? theme.textTheme.bodyMedium,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obscureText,
        focusNode: focusNode,
        textAlign: textAlign,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        decoration: (decoration ??
                const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ))
            .copyWith(
          hintText: hintText ?? decoration?.hintText,
          hintStyle: decoration?.hintStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.textTheme.bodyMedium?.color!.withValues(alpha: 0.5),
              ),
          suffixText: suffixText ?? decoration?.suffixText,
          suffixIcon: suffixIcon ?? decoration?.suffixIcon,
          prefixIcon: prefixIcon ?? decoration?.prefixIcon,
          prefixText: prefixText ?? decoration?.prefixText,
          errorText: errorText ?? decoration?.errorText,
        ),
      ),
    );
  }
}

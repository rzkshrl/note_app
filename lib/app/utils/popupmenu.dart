import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

PopupMenuItem buildPopupMenuItem(
    String title, int position, TextStyle textStyle, void Function()? onTap) {
  return PopupMenuItem(
    value: position,
    onTap: onTap,
    child: SizedBox(
      width: 30.w,
      child: Text(
        title,
        style: textStyle,
      ),
    ),
  );
}

PopupMenuDivider buildPopupMenuDivider() {
  return PopupMenuDivider(
    height: 0.5.h,
  );
}

class CustomPopupMenuDivider extends PopupMenuDivider {
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const CustomPopupMenuDivider({
    super.height,
    super.key,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  }) : super();

  @override
  State<CustomPopupMenuDivider> createState() => _CustomPopupMenuDividerState();
}

class _CustomPopupMenuDividerState extends State<CustomPopupMenuDivider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 3.2.w, left: 3.2.w),
      child: Divider(
        height: 0,
        thickness: widget.thickness,
        indent: widget.indent,
        endIndent: widget.endIndent,
        color: widget.color,
      ),
    );
  }
}

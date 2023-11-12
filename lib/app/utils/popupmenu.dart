import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/app/utils/sql_helper.dart';
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

Widget popupMenuBtn(BuildContext context,
    void Function(void Function() fn) setState, promptDeleteAllItems) {
  return PopupMenuButton<dynamic>(
      tooltip: '',
      icon: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Icon(
            Icons.more_vert_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      offset: Offset(-2.5.w, 5.5.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      itemBuilder: (context) => [
            buildPopupMenuItem(
                'Delete items',
                2,
                Theme.of(context)
                    .popupMenuTheme
                    .textStyle!
                    .copyWith(fontSize: 10.sp), () {
              setState(() {
                promptDeleteAllItems(
                  context,
                  () {
                    setState(() {
                      SQLHelper().deleteAllItem();
                      Navigator.of(context).pop();
                    });
                  },
                );
              });
            }),
          ]);
}

Widget mainTitleBtn(
  BuildContext context,
) {
  return PopupMenuButton<dynamic>(
      tooltip: '',
      icon: const ClipOval(
        child: Material(
          color: Colors.transparent,
          child: FaIcon(
            FontAwesomeIcons.caretDown,
            size: 18,
          ),
        ),
      ),
      offset: Offset(-2.5.w, 5.5.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      itemBuilder: (context) => [
            buildPopupMenuItem(
                'Profile',
                1,
                Theme.of(context)
                    .popupMenuTheme
                    .textStyle!
                    .copyWith(fontSize: 10.sp),
                () {}),
            CustomPopupMenuDivider(
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            ),
            buildPopupMenuItem(
                'Delete items',
                2,
                Theme.of(context)
                    .popupMenuTheme
                    .textStyle!
                    .copyWith(fontSize: 10.sp),
                () {}),
          ]);
}

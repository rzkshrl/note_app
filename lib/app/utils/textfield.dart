// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

Widget searchBox(
    bool isLongPressed,
    BuildContext context,
    TextEditingController searchTextController,
    void Function(String)? onChanged) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  return Form(
    child: SizedBox(
      height: 5.h,
      child: TextFormField(
        enabled: !isLongPressed,
        controller: searchTextController,
        style: Theme.of(context).textTheme.headlineSmall,
        onChanged: onChanged,
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        onTapOutside: (event) {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        toolbarOptions: const ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        decoration: InputDecoration(
          hintText: 'Search notes',
          hintStyle: isLongPressed
              ? Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 12.sp)
              : Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 12.sp),
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 0.8.w,
            ),
            child: Align(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 18,
                  color: isLongPressed
                      ? Theme.of(context).iconTheme.color!.withOpacity(0.3)
                      : Theme.of(context).iconTheme.color,
                )),
          ),
          filled: true,
          fillColor: isLongPressed
              ? Theme.of(context).cardColor.withOpacity(0.4)
              : Theme.of(context).cardColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none),
        ),
      ),
    ),
  );
}

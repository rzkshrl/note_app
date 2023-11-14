import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/theme/theme.dart';
import 'package:note_app/app/utils/popupmenu.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

Widget buildDialogAllNotesCategory(
    bool isSliverAppBarExpanded,
    BuildContext context,
    String currentRoute,
    List<Map<String, dynamic>> notesDataAll,
    List<Map<String, dynamic>> notesDataFavorited) {
  return Padding(
    padding: EdgeInsets.only(top: isSliverAppBarExpanded ? 6.h : 17.h),
    child: Dialog(
      backgroundColor: Theme.of(context).popupMenuTheme.color,
      surfaceTintColor: Theme.of(context).popupMenuTheme.color,
      // backgroundColor: yellow,
      // surfaceTintColor: yellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.topLeft,
      insetPadding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: Container(
        height: 16.h,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 0.6.h, left: 0.6.w, right: 0.6.w),
          child: Center(
            child: Column(
              children: [
                buildDrawerItemSingle(
                    text: Text(
                      'All Notes',
                      style: (currentRoute == homeViewRoute)
                          ? Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp, color: blue2)
                          : Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp),
                    ),
                    text2: Text(
                      notesDataAll.length.toString(),
                      style: (currentRoute == homeViewRoute)
                          ? Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp, color: blue2)
                          : Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp),
                    ),
                    icon: PhosphorIcons.regular.notebook,
                    iconColor: (currentRoute == homeViewRoute)
                        ? blue2
                        : Theme.of(context).iconTheme.color,
                    visualDensity: const VisualDensity(vertical: 3),
                    iconSize: 26,
                    tileColor: (currentRoute == homeViewRoute)
                        ? blue3
                        : Theme.of(context).popupMenuTheme.color,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacementNamed(homeViewRoute);
                    }),
                CustomPopupMenuDivider(
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                ),
                buildDrawerItemSingle(
                    text: Text(
                      'My favorites',
                      style: (currentRoute == favoritesViewRoute)
                          ? Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp, color: blue2)
                          : Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp),
                    ),
                    text2: Text(
                      notesDataFavorited.length.toString(),
                      style: (currentRoute == favoritesViewRoute)
                          ? Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp, color: blue2)
                          : Theme.of(context)
                              .popupMenuTheme
                              .textStyle!
                              .copyWith(fontSize: 10.sp),
                    ),
                    icon: PhosphorIcons.regular.star,
                    iconColor: (currentRoute == favoritesViewRoute)
                        ? blue2
                        : Theme.of(context).iconTheme.color,
                    visualDensity: const VisualDensity(vertical: 3),
                    iconSize: 26,
                    tileColor: (currentRoute == favoritesViewRoute)
                        ? blue3
                        : Theme.of(context).popupMenuTheme.color,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushReplacementNamed(favoritesViewRoute);
                    }),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildDrawerItemSingle(
    {required Text text,
    required Text text2,
    required IconData icon,
    required double iconSize,
    required VisualDensity visualDensity,
    required Color? iconColor,
    required Color? tileColor,
    required VoidCallback onTap}) {
  return ListTile(
    leading: SizedBox(
      height: double.infinity,
      child: Icon(icon, color: iconColor, size: iconSize),
    ),
    trailing: text2,
    title: text,
    minLeadingWidth: 0,
    splashColor: Colors.transparent,
    visualDensity: visualDensity,
    tileColor: tileColor,
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}

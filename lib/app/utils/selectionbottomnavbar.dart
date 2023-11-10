import 'package:flutter/material.dart';
import 'package:note_app/app/utils/button.dart';
import 'package:note_app/app/utils/constants.dart';
import 'package:note_app/app/utils/modalsheet.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

Widget showSelectionBottomBar(
    BuildContext context,
    List<bool> selectedItems,
    Set<int> selectedNoteIds,
    List<Map<String, dynamic>> notesData,
    bool isClicked,
    bool allSelectedItems,
    bool isLongPressed,
    void setState(void Function() fn),
    void Function() clear,
    Widget btnLongPressedItemHomeSelectAll) {
  // call string constants
  var constants = Constants();

  return Container(
    height: 6.h,
    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnLongPressedItemHome(
          selectedItems,
          context,
          PhosphorIcon(
            PhosphorIcons.fill.pushPin,
            color: selectedItems.contains(true)
                ? Theme.of(context).iconTheme.color
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          ),
          'Pin',
          () {
            setState(() {
              isClicked = !isClicked;
            });
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                isClicked = false;
              });
            });
            //action
            setState(() {
              for (var item in notesData) {
                if (selectedNoteIds.contains(item[constants.id])) {
                  if (item[constants.pin] == 0) {
                    SQLHelper().pinItem(true, selectedNoteIds.toList());
                  } else {
                    SQLHelper().pinItem(false, selectedNoteIds.toList());
                  }
                  debugPrint('pinned item nih : ${item[constants.pin]}');
                }
              }
            });
            clear();
          },
          (details) {
            setState(() {
              isClicked = !isClicked;
            });
            //action
            setState(() {
              for (var item in notesData) {
                if (selectedNoteIds.contains(item[constants.id])) {
                  if (item[constants.pin] == 0) {
                    SQLHelper().pinItem(true, selectedNoteIds.toList());
                  } else {
                    SQLHelper().pinItem(false, selectedNoteIds.toList());
                  }
                  debugPrint('pinned item nih : ${item[constants.pin]}');
                }
              }
            });
            clear();
          },
        ),
        btnLongPressedItemHome(
          selectedItems,
          context,
          PhosphorIcon(
            PhosphorIcons.regular.star,
            color: selectedItems.contains(true)
                ? Theme.of(context).iconTheme.color
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          ),
          'Favorite',
          () {
            setState(() {
              isClicked = !isClicked;
            });
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                isClicked = false;
              });
            });
            //action
          },
          (details) {
            setState(() {
              isClicked = !isClicked;
            });
            //action
          },
        ),
        btnLongPressedItemHome(
          selectedItems,
          context,
          PhosphorIcon(
            PhosphorIcons.regular.trashSimple,
            color: selectedItems.contains(true)
                ? Theme.of(context).iconTheme.color
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          ),
          'Delete',
          () {
            setState(() {
              isClicked = !isClicked;
            });
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                isClicked = false;
              });
            });
            //action
            promptDeleteItems(context, () {
              SQLHelper().deleteItem(selectedNoteIds.toList());
              clear();
              Navigator.pop(context);
            });
          },
          (details) {
            setState(() {
              isClicked = !isClicked;
            });
            //action
            promptDeleteItems(context, () {
              SQLHelper().deleteItem(selectedNoteIds.toList());
              clear();
              Navigator.pop(context);
            });
          },
        ),
        btnLongPressedItemHomeSelectAll,
      ],
    ),
  );
}

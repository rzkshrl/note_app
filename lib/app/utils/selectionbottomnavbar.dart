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
    bool isLongPressed) {
  return StatefulBuilder(builder: (context, setState) {
    // call string constants
    var constants = Constants();
    return Container(
      height: 6.h,
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btnLongPressedItemHome(
            selectedItems,
            context,
            PhosphorIcon(
              PhosphorIcons.regular.pushPin,
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
                setState(() {
                  isLongPressed = false;
                  selectedItems.clear();
                  selectedNoteIds.clear();
                });
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
                setState(() {
                  isLongPressed = false;
                  selectedItems.clear();
                  selectedNoteIds.clear();
                });
                Navigator.pop(context);
              });
            },
          ),
          btnLongPressedItemHomeSelectAll(
            allSelectedItems,
            context,
            PhosphorIcon(
              !allSelectedItems
                  ? PhosphorIcons.regular.checkSquare
                  : PhosphorIcons.fill.checkSquare,
              color: !allSelectedItems
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).floatingActionButtonTheme.backgroundColor,
            ),
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
              allSelectedItems = !allSelectedItems;
              if (allSelectedItems) {
                for (var item in notesData) {
                  selectedNoteIds.add(item[constants.id]);
                }
                selectedItems = List<bool>.generate(
                    selectedNoteIds.length, (index) => false);
                for (var i = 0; i < selectedItems.length; i++) {
                  selectedItems[i] = true;
                }
                debugPrint('select all');
                debugPrint('selectedNoteIds : $selectedNoteIds');
              } else if (!allSelectedItems) {
                for (var item in notesData) {
                  selectedNoteIds.remove(item[constants.id]);
                }
                selectedItems = List<bool>.generate(
                    selectedNoteIds.length, (index) => false);
                for (var i = 0; i < selectedItems.length; i++) {
                  selectedItems[i] = false;
                  allSelectedItems = false;
                  debugPrint('deselect all');
                  debugPrint('selectedNoteIds : $selectedNoteIds');
                }
              }
            },
            (details) {
              setState(() {
                isClicked = !isClicked;
              });
              //action
              allSelectedItems = !allSelectedItems;
              if (allSelectedItems) {
                for (var item in notesData) {
                  selectedNoteIds.add(item[constants.id]);
                }
                selectedItems = List<bool>.generate(
                    selectedNoteIds.length, (index) => false);
                for (var i = 0; i < selectedItems.length; i++) {
                  selectedItems[i] = true;
                }
                debugPrint('select all');
                debugPrint('selectedNoteIds : $selectedNoteIds');
              } else if (!allSelectedItems) {
                for (var item in notesData) {
                  selectedNoteIds.remove(item[constants.id]);
                }
                selectedItems = List<bool>.generate(
                    selectedNoteIds.length, (index) => false);
                for (var i = 0; i < selectedItems.length; i++) {
                  selectedItems[i] = false;
                  allSelectedItems = false;
                  debugPrint('deselect all');
                  debugPrint('selectedNoteIds : $selectedNoteIds');
                }
              }
            },
          ),
        ],
      ),
    );
  });
}

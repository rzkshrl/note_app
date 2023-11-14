import 'package:flutter/material.dart';
import 'package:note_app/app/theme/theme.dart';
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
    void Function(void Function() fn) setState,
    void Function() clear,
    Widget btnLongPressedItemHomeSelectAll) {
  // call string constants
  var constants = Constants();

  String textPin() {
    String text = 'Pin';
    for (var item in notesData) {
      if (selectedNoteIds.contains(item[constants.id])) {
        if (item[constants.pin] == 0) {
          text = 'Pin';
        } else {
          text = 'Unpin';
        }
      }
    }
    return text;
  }

  String textFavorite() {
    String text = 'Favorite';
    for (var item in notesData) {
      if (selectedNoteIds.contains(item[constants.id])) {
        if (item[constants.favorite] == 0) {
          text = 'Favorite';
        } else {
          text = 'Unfavorite';
        }
      }
    }
    return text;
  }

  PhosphorIcon iconPin() {
    PhosphorIcon icon = PhosphorIcon(
      PhosphorIcons.regular.pushPin,
      color: selectedItems.contains(true)
          ? Theme.of(context).iconTheme.color
          : Theme.of(context).iconTheme.color!.withOpacity(0.2),
    );
    for (var item in notesData) {
      if (selectedNoteIds.contains(item[constants.id])) {
        if (item[constants.pin] == 0) {
          icon = PhosphorIcon(
            PhosphorIcons.regular.pushPin,
            color: selectedItems.contains(true)
                ? Theme.of(context).iconTheme.color
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          );
        } else {
          icon = PhosphorIcon(
            PhosphorIcons.fill.pushPin,
            color: selectedItems.contains(true)
                ? Theme.of(context).floatingActionButtonTheme.backgroundColor
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          );
        }
      }
    }
    return icon;
  }

  PhosphorIcon iconFavorite() {
    PhosphorIcon icon = PhosphorIcon(
      PhosphorIcons.regular.star,
      color: selectedItems.contains(true)
          ? Theme.of(context).iconTheme.color
          : Theme.of(context).iconTheme.color!.withOpacity(0.2),
    );
    for (var item in notesData) {
      if (selectedNoteIds.contains(item[constants.id])) {
        if (item[constants.favorite] == 0) {
          icon = PhosphorIcon(
            PhosphorIcons.regular.star,
            color: selectedItems.contains(true)
                ? Theme.of(context).iconTheme.color
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          );
        } else {
          icon = PhosphorIcon(
            PhosphorIcons.fill.star,
            color: selectedItems.contains(true)
                ? yellow
                : Theme.of(context).iconTheme.color!.withOpacity(0.2),
          );
        }
      }
    }
    return icon;
  }

  return Container(
    height: 6.h,
    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnLongPressedItemHome(
          selectedItems,
          context,
          iconPin(),
          textPin(),
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
              if (selectedItems.contains(true)) {
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
              } else {
                return;
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
              if (selectedItems.contains(true)) {
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
              } else {
                return;
              }
            });
            clear();
          },
        ),
        btnLongPressedItemHome(
          selectedItems,
          context,
          iconFavorite(),
          textFavorite(),
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
              if (selectedItems.contains(true)) {
                for (var item in notesData) {
                  if (selectedNoteIds.contains(item[constants.id])) {
                    if (item[constants.favorite] == 0) {
                      SQLHelper().favoriteItem(true, selectedNoteIds.toList());
                    } else {
                      SQLHelper().favoriteItem(false, selectedNoteIds.toList());
                    }
                    debugPrint(
                        'favorited item nih : ${item[constants.favorite]}');
                  }
                }
              } else {
                return;
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
              if (selectedItems.contains(true)) {
                for (var item in notesData) {
                  if (selectedNoteIds.contains(item[constants.id])) {
                    if (item[constants.favorite] == 0) {
                      SQLHelper().favoriteItem(true, selectedNoteIds.toList());
                    } else {
                      SQLHelper().favoriteItem(false, selectedNoteIds.toList());
                    }
                    debugPrint(
                        'favorited item nih : ${item[constants.favorite]}');
                  }
                }
              } else {
                return;
              }
            });
            clear();
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
            if (selectedItems.contains(true)) {
              promptDeleteItems(context, () {
                SQLHelper().deleteItem(selectedNoteIds.toList());
                clear();
                Navigator.pop(context);
              });
            } else {
              return;
            }
          },
          (details) {
            setState(() {
              isClicked = !isClicked;
            });
            //action
            if (selectedItems.contains(true)) {
              promptDeleteItems(context, () {
                SQLHelper().deleteItem(selectedNoteIds.toList());
                clear();
                Navigator.pop(context);
              });
            } else {
              return;
            }
          },
        ),
        btnLongPressedItemHomeSelectAll,
      ],
    ),
  );
}

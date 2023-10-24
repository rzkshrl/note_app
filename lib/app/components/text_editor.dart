// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:note_app/app/routes/navigation_service.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/utils/constants.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:sizer/sizer.dart';

import '../utils/modalsheet.dart';
import '../utils/snackbar.dart';

class TextEditor extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final args;
  const TextEditor({this.args, super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  String noteTitle = '';
  String noteText = '';

  String noteTitleOnChange = '';
  String noteTextOnChange = '';

  var constants = Constants();

  var titleTextController = TextEditingController();
  var textTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteText = textTextController.text.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    noteTitle = (widget.args[0] == 'new' ? '' : widget.args[1][1]);
    noteText = (widget.args[0] == 'new' ? '' : widget.args[1][2]);

    titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1][1]);
    textTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1][2]);
    titleTextController.addListener(handleTitleTextChange);
    textTextController.addListener(handleNoteTextChange);
    debugPrint('TEST ARGUMENTASI DIMENSI : ${widget.args[0]}');
  }

  @override
  void dispose() {
    titleTextController.dispose();
    textTextController.dispose();
    super.dispose();
  }

  Future<void> handleBack() async {
    final dateTimeNow = DateTime.now().toIso8601String();
    if (noteTitle.isEmpty) {
      // go back/dismiss page without saving
      if (noteText.isEmpty) {
        if (widget.args[0] == 'new') {
          Navigator.of(context).pushReplacementNamed(homeViewRoute);
        }
      } else {
        String title = noteText.split('\n')[0];
        if (title.length > 16) {
          title = title.substring(0, 16);
        }
        setState(() {
          noteTitle = title;
        });
        if (widget.args[0] == 'new') {
          try {
            await SQLHelper().createItem(noteTitle, noteText, dateTimeNow);
            Navigator.of(context).pushReplacementNamed(homeViewRoute);
          } catch (e) {
            SnackBarService.showSnackBar(
              content: const Text("Can't save note."),
            );
            debugPrint('$e');
          }
        }
      }
    }
    setState(() {
      debugPrint('ini noteTitle ${widget.args[1][1]}');
      debugPrint('ini noteTitleOnChange ${noteTitleOnChange}');
      debugPrint('ini titleTextController ${titleTextController.text}');
      debugPrint('-------------------------------------------------');
      debugPrint('ini noteText ${widget.args[1][2]}');
      debugPrint('ini noteTextOnChange ${noteTextOnChange}');
      debugPrint('ini textTextController ${textTextController.text}');
    });
    if (widget.args[0] == 'update') {
      if (widget.args[1][1] != titleTextController.text ||
          widget.args[1][2] != textTextController.text) {
        Navigator.of(context).pushReplacementNamed(homeViewRoute);
      } else {
        await Future.delayed(Duration(milliseconds: 50));
        promptSaveUpdatedItems(context, () {
          Navigator.of(context).pushReplacementNamed(homeViewRoute);
        }, () {
          try {
            SQLHelper().updateItem(
                noteTitle, noteText, widget.args[1][0], dateTimeNow);
          } catch (e) {
            SnackBarService.showSnackBar(
              content: const Text("Can't save note."),
            );
            debugPrint('$e');
          }
        });
      }
    }
  }

  Future<void> saveNotes() async {
    final dateTimeNow = DateTime.now().toIso8601String();
    if (noteTitle.isEmpty) {
      // go back/dismiss page without saving
      if (noteText.isEmpty) {
        Navigator.of(context).pushReplacementNamed(homeViewRoute);
      } else {
        String title = noteText.split('\n')[0];
        if (title.length > 16) {
          title = title.substring(0, 16);
        }
        setState(() {
          noteTitle = title;
        });
        if (widget.args[0] == 'new') {
          try {
            await SQLHelper().createItem(noteTitle, noteText, dateTimeNow);
          } catch (e) {
            SnackBarService.showSnackBar(
              content: const Text("Can't save note."),
            );
            debugPrint('$e');
          }
        }
      }
    }
    if (widget.args[0] == 'update') {
      try {
        SQLHelper()
            .updateItem(noteTitle, noteText, widget.args[1][0], dateTimeNow);
      } catch (e) {
        SnackBarService.showSnackBar(
          content: const Text("Can't save note."),
        );
        debugPrint('$e');
      }
    }
  }

  String extractDatefromTimeStamp() {
    if (widget.args[0] == 'new') {
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('MMM dd').format(currentDate);

      if (currentDate.year == currentDate.year &&
          currentDate.month == currentDate.month &&
          currentDate.day == currentDate.day) {
        return 'Today';
      } else {
        return formattedDate;
      }
    } else {
      final currentDate = DateTime.now();
      final date = DateTime.parse(widget.args[1][3]);
      final formattedDate = DateFormat('MMM dd').format(date);

      if (currentDate.year == date.year &&
          currentDate.month == date.month &&
          currentDate.day == date.day) {
        return 'Today';
      } else {
        return formattedDate;
      }
    }
  }

  String extractTimefromTimeStamp() {
    if (widget.args[0] == 'new') {
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('hh:mm a').format(currentDate);

      return formattedDate;
    } else {
      final date = DateTime.parse(widget.args[1][3]);
      final formattedDate = DateFormat('hh:mm a').format(date);
      return formattedDate;
    }
  }

  Future<bool> _onWillPop() async {
    handleBack();
    await Navigator.of(context).pushReplacementNamed(homeViewRoute);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // nanti bikin ini bisa sesuai languange hp yaa, jadi datetime format sesuai

    // NavigationService service = NavigationService();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: false,
              toolbarHeight: 6.h,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      handleBack();
                    },
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.undoAlt),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            promptSaveUpdatedItems(context, () {}, () {});
                          });
                        },
                        icon: const FaIcon(FontAwesomeIcons.redoAlt),
                      ),
                      IconButton(
                        onPressed: () {
                          saveNotes();

                          Navigator.of(context)
                              .pushReplacementNamed(homeViewRoute);
                        },
                        icon: const FaIcon(FontAwesomeIcons.check),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 2, (context, index) {
                return index == 0
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, top: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: SizedBox(
                                height: 4.h,
                                child: TextFormField(
                                  controller: titleTextController,
                                  onChanged: (text) {
                                    setState(() {
                                      if (widget.args[0] == 'update') {
                                        noteTitleOnChange = text;
                                      }
                                    });
                                  },
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 24.sp),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Title',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 24.sp),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: Text(
                                '${extractDatefromTimeStamp()}, ${extractTimefromTimeStamp()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 10.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h),
                        child: TextFormField(
                          controller: textTextController,
                          onChanged: (text) {
                            setState(() {
                              if (widget.args[0] == 'update') {
                                noteTextOnChange = text;
                              }
                            });
                          },
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 15.sp),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: widget.args[0] == 'new' ? true : false,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: true,
                            selectAll: true,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Write here',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 15.sp),
                          ),
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

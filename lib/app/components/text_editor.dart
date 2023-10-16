// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/app/routes/navigation_service.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/utils/sql_helper.dart';
import 'package:sizer/sizer.dart';

import '../utils/snackbar.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  String noteTitle = '';
  String noteText = '';

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
    titleTextController.addListener(handleTitleTextChange);
    textTextController.addListener(handleNoteTextChange);
  }

  @override
  void dispose() {
    titleTextController.dispose();
    textTextController.dispose();
    super.dispose();
  }

  void handleBack() async {
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
        try {
          await SQLHelper().createItem(noteTitle, noteText);
        } catch (e) {
          SnackBarService.showSnackBar(
            content: const Text("Can't save note."),
          );
          debugPrint('$e');
        }
        debugPrint(noteTitle);
      }
    }
  }

  String extractDatefromTimeStamp() {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('MMM dd').format(currentDate);

    if (currentDate.year == currentDate.year &&
        currentDate.month == currentDate.month &&
        currentDate.day == currentDate.day) {
      return 'Today';
    } else {
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
    final dateFormatter = DateFormat('hh:mm a');
    NavigationService service = NavigationService();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: false,
              toolbarHeight: 6.h,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // service.goBack();
                      Navigator.of(context).pushReplacementNamed(homeViewRoute);
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
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.redoAlt),
                      ),
                      IconButton(
                        onPressed: () {
                          handleBack();
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
                                '${extractDatefromTimeStamp()}, ${dateFormatter.format(DateTime.now())}',
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 15.sp),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: true,
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

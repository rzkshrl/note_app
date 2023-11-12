import 'package:flutter/material.dart';

import 'flexiblespacebar.dart';

toggleTitleHome(
    bool isLongPressed,
    BuildContext context,
    onTapButtonX,
    String getSelectedItemCount,
    onTapAllNotes,
    cAniAllNotes,
    notesData,
    bool isRotated) {
  if (isLongPressed) {
    return buildSelectionTitle(
      context,
      onTapButtonX,
      "$getSelectedItemCount selected",
    );
  } else {
    return buildHomeTitle(context, onTapAllNotes, cAniAllNotes,
        '${notesData.length} Notes', isRotated);
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ShowModal on Widget {
  Future<T?> showModalPopup<T>(
    BuildContext context,
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => this,
      barrierDismissible: false,
    );
  }

  Future<T?> showModalSheet<T>(
    BuildContext context,
  ) {
    return showCupertinoModalSheet(
      context: context,
      builder: (BuildContext context) => this,
    );
  }
}

extension ShowDialog on Widget {
  void showAlert(
    BuildContext context, {
    bool barrierDismissible = true,
  }) {
    unawaited(showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: this,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.2),
    ));
  }
}

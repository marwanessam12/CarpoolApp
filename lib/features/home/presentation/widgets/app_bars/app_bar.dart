import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  MyAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null, // Check if title is null

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios, // iOS-style back arrow
          color: Colors.blue, // iOS blue color
        ),
        onPressed: () {
          Navigator.of(context).pop(); // Go back to the previous screen
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

Widget buildSignInButton({
    required dynamic icon,
    required Widget child,
    VoidCallback? onPressed,
  }) {
    return Container(
      height: 40,
      width: 240,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.fromLTRB(8, 0, 0, 0)),
        ),
        child: SizedBox(
          width: 240,
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon is IconData
                  ? Icon(icon, size: 40)
                  : Image(image: icon, width: 40),
              const VerticalDivider(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
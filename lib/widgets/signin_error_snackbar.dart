import 'package:copy_todo_mvc/models/app_color.dart';
import 'package:flutter/material.dart';

SnackBar signinErrorSnackBar(BuildContext context, String error) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).cardColor,
    content: SizedBox(
      height: 40,
      child: Row(
        children: [
          const Icon(Icons.error, color: AppColor.titleRed,),
          const SizedBox(width: 10),
          Text(error, style: Theme.of(context).textTheme.labelSmall?.merge(const TextStyle(color: AppColor.titleRed)),),
        ],
      ),
    ),
  );
}

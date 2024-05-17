import 'package:copy_todo_mvc/models/app_color.dart';
import 'package:flutter/material.dart';

SnackBar signinErrorSnackBar(BuildContext context, String error) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Theme.of(context).cardColor,
    duration: const Duration(seconds: 7),
    content: Row(
      children: [
        const Icon(Icons.error, color: AppColor.titleRed,),
        const SizedBox(width: 10),
        Expanded(child: Text(error, style: Theme.of(context).textTheme.labelSmall?.merge(const TextStyle(color: AppColor.titleRed)), maxLines: 4, overflow: TextOverflow.ellipsis,)),
      ],
    ),
  );
}

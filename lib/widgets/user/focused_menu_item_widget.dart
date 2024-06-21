import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class FocusedMenu extends StatelessWidget {
  final Widget widget;
  final double? menuWidth;
  final VoidCallback onClick;
  final List<FocusedMenuItem>? menuItems;
  final Function deleteButton;
  final Function editButton;
  const FocusedMenu({super.key,
      required this.widget,
      this.menuWidth,
      required this.onClick,
      this.menuItems,
      required this.deleteButton,
      required this.editButton});

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: menuWidth ?? MediaQuery.of(context).size.width * 0.5,
      menuItems: menuItems ??
          [
            FocusedMenuItem(
              backgroundColor: Colors.grey,
              title: const Text('تعديل'),
              trailingIcon: const Icon(Icons.edit),
              onPressed: editButton,
            ),
            FocusedMenuItem(
              title: const Text(
                'حذف',
                // ignore: prefer_const_constructors
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              trailingIcon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: deleteButton,
            )
          ],
      onPressed: onClick,
      menuBoxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      menuOffset: 10,
      openWithTap: false,
      child: widget,
    );
  }
}

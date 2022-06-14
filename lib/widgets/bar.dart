import 'package:flutter/material.dart';

class FaskoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final Widget? leading;

  const FaskoAppBar({Key? key, this.actions = const [], this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Fasko',
          style: TextStyle(
            color: Color.fromARGB(255, 193, 54, 86),
            fontWeight: FontWeight.w600,
            fontFamily: 'Jost',
            fontSize: 24,
          )),
      centerTitle: true,
      leading: leading,
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey,
      elevation: 0,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          color: Colors.grey[200],
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

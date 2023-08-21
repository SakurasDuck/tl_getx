import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ItemViewWrap extends StatelessWidget {
  const ItemViewWrap({required this.itemBinds, required this.child, Key? key})
      : super(key: key);

  final List<Bind> itemBinds;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Binds(
      binds: itemBinds,
      child: child,
    );
  }
}

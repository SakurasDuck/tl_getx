import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogicWrap<T extends GetLifeCycleMixin> extends StatefulWidget {
  const LogicWrap(
      {required this.child, required this.getInstance, this.tag, Key? key})
      : super(key: key);

  final String? tag;

  final GetLogicInstance<T> getInstance;

  final Widget child;

  @override
  _LogicWrapState createState() => _LogicWrapState<T>();
}

class _LogicWrapState<T extends GetLifeCycleMixin> extends State<LogicWrap> {
  /// 是否由当前页面注册
  bool _isRegisteredByCurrentPage = false;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    final isRegistered = Get.isRegistered<T>(tag: widget.tag);
    if (!isRegistered) {
      Get.lazyPut<T>(() => widget.getInstance() as T, tag: widget.tag);
      _isRegisteredByCurrentPage = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (Get.isRegistered<T>(tag: widget.tag) && _isRegisteredByCurrentPage) {
      Get.delete<T>(tag: widget.tag);
    }
    super.dispose();
  }
}

typedef GetLogicInstance<T extends GetLifeCycleMixin> = T Function();

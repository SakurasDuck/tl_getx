import 'dart:collection';

import 'package:get/get.dart';

import '../get_common/gets_controller.dart';

part 'rt_list.dart';

///列表自加载itemLogic mixin
///[T] list item state
///[K] list item logic
mixin RxListMixin<T, K extends GetSController<T>> on GetLifeCycleMixin
    implements RxConnector<K>, ItemBindConnector<K> {
  late final RTList<K> itemList;

  bool _removeItemLogicsWhenClose = true;

  /// 是否在onClose时删除itemLogic
  /// 是onClose不一定是退路由触发，itemLogic没有remove
  /// 退路由一定触发onClose
  set removeItemLogicsWhenClose(bool removeItemLogicsWhenClose) =>
      _removeItemLogicsWhenClose = removeItemLogicsWhenClose;

  @override
  void onInit() {
    super.onInit();
    itemList = RTList<K>(
        item2LogicTag: item2LogicTag,
        itemBind: (K val, tag) => itemBind(val, tag));
  }

  List<Bind> itemIndex2binds(int index) =>
      itemList._binds[itemIndex2Tag(index)]!;

  String itemIndex2Tag(int index) => itemList._tagValues[index];

  @override
  void onClose() {
    super.onClose();
    if (_removeItemLogicsWhenClose) {
      itemList.forEach((element) {
        final tag = itemList.item2LogicTag(element);
        Get.delete<K>(tag: tag, force: true);
      });
    }
  }
}

///连接器
///[T] list item 泛型
///[P] list item logic 泛型
abstract class RxConnector<T> {
  String item2LogicTag(T t);
}

abstract class ItemBindConnector<T> {
  List<Bind> itemBind(T t, String tag);
}

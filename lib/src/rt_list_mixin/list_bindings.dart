import 'package:get/get.dart';

///listItem 依赖bind
abstract class ListItemBindings<T> {
  List<Bind> itemDependencies(T item, String tag);
}

abstract class ItemBind<S> extends Bind<S> {
  const ItemBind({required super.child});

  static Bind lazyPut<S>(
    InstanceBuilderCallback<S> builder, {
    String? tag,
    bool fenix = false,
    VoidCallback? onClose,
    bool autoRemove = false,
  }) {
    return Bind.lazyPut<S>(builder,
        tag: tag, fenix: fenix, onClose: onClose, autoRemove: autoRemove);
  }
}

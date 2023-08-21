part of 'rx_list_mixin.dart';

typedef Item2LogicTagFunc<T> = String Function(T);

typedef GetItemBind<T> = List<Bind> Function(T, String);

typedef Tag2ItemFunc<T> = T Function(String tag, [bool byFind]);

/// Create a list similar to `List<T>`
class RTList<E> extends GetListenable<List<String>>
    with ListMixin<E>, RxObjectMixin<List<String>> {
  RTList({required this.item2LogicTag,
    required this.itemBind,
    // required this.tag2ItemState,
  })
      : super(<String>[]);

  // final Tag2ItemFunc<E> tag2ItemState;

  final Item2LogicTagFunc<E> item2LogicTag;

  final List<String> _tagValues = [];

  final Map<String, List<Bind>> _binds = {};

  final GetItemBind<E> itemBind;

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  void operator []=(int index, E val) {
    final tag = item2LogicTag(val);
    if (!_tagValues.contains(tag)) {
      _binds.addAll({tag: itemBind(val, tag)});
    }
    _tagValues[index] = tag;
    refresh();
  }

  /// Special override to push() element(s) in a reactive way
  /// inside the List,
  @override
  RTList<E> operator +(Iterable<E> val) {
    addAll(val);
    return this;
  }

  @override
  void refresh() {
    super.refresh();
  }

  @override
  E operator [](int index) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return Get.find<E>(tag: _tagValues[index]);
  }

  Iterable<E> get _values {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.map((e) => Get.find<E>(tag: e));
  }

  @override
  void add(E element) {
    final tag = item2LogicTag(element);
    if (!_tagValues.contains(tag)) {
      _binds.addAll({tag: itemBind(element, tag)});
    }
    _tagValues.add(tag);
    refresh();
  }

  @override
  void insert(int index, E element) {
    final tag = item2LogicTag(element);
    if (!_tagValues.contains(tag)) {
      _binds.addAll({tag: itemBind(element, tag)});
    }
    _tagValues.insert(index, tag);
    refresh();
  }

  @override
  void addAll(Iterable<E> iterable) {
    for (final item in iterable) {
      final tag = item2LogicTag(item);
      if (!_tagValues.contains(tag)) {
        _binds.addAll({tag: itemBind(item, tag)});
      }
      _tagValues.add(tag);
    }
    refresh();
  }

  //
  // Iterable<E> get _getValuesByNotFind {
  //   return _tagValues.map((e) => tag2ItemState(e, false));
  // }

  @override
  void removeWhere(bool test(E element)) {
    _tagValues.removeWhere((e) {
      final result = test(Get.find<E>(tag: e));
      if (result) {
        _binds.remove(e);
      }
      return result;
    });
    refresh();
  }

  @override
  bool remove(Object? element) {
    if (element != null && element is E) {
      final tag = item2LogicTag(element as E);
      final result = _tagValues.remove(tag);
      _binds.remove(tag);
      refresh();
      return result;
    } else {
      return false;
    }
  }

  @override
  E get last {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return Get.find<E>(tag: _tagValues.last);
  }

  @override
  E get first {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return Get.find<E>(tag: _tagValues.first);
  }

  @override
  Iterable<E> take(int count) {
    return _tagValues.take(count).map((e) => Get.find<E>(tag: e));
  }

  @override
  int lastIndexWhere(bool test(E element), [int? start]) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.lastIndexWhere((e) => test(Get.find<E>(tag: e)));
  }

  @override
  void forEach(void action(E element)) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    _tagValues.forEach((e) => action(Get.find<E>(tag: e)));
    refresh();
  }

  @override
  List<E> sublist(int start, [int? end]) {
    return _tagValues
        .sublist(start, end)
        .map((e) => Get.find<E>(tag: e))
        .toList();
  }

  @override
  void clear() {
    _tagValues.clear();
    _binds.clear();
    refresh();
  }

  @override
  int indexWhere(bool test(E element), [int start = 0]) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.indexWhere((e) => test(Get.find<E>(tag: e)), start);
  }

  @override
  E removeLast() {
    final tag = _tagValues.removeLast();
    final item = Get.find<E>(tag: tag);
    refresh();
    _binds.remove(tag);
    return item;
  }

  @override
  bool every(bool test(E element)) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.every((e) => test(Get.find<E>(tag: e)));
  }

  @override
  bool any(bool test(E element)) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.any((e) => test(Get.find<E>(tag: e)));
  }

  @override
  bool contains(Object? element) {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.any((e) => Get.find<E>(tag: e) == element);
  }

  @override
  bool get isNotEmpty {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.isNotEmpty;
  }

  @override
  bool get isEmpty {
    // RxInterface.proxy?.addListener(subject);
    reportRead();
    return _tagValues.isEmpty;
  }

  @override
  List<R> cast<R>() {
    return List.castFrom<E, R>(toList());
  }

  @override
  Iterable<E> skip(int count) {
    reportRead();
    return _tagValues.skip(count).map((e) => Get.find<E>(tag: e));
  }

  @override
  int indexOf(Object? element, [int start = 0]) {
    if (start < 0) start = 0;
    if (element is! E) {
      return -1;
    }
    return _tagValues.indexOf(item2LogicTag(element));
  }

  @override
  List<E> toList({bool growable = true}) {
    reportRead();
    return _tagValues
        .map((e) => Get.find<E>(tag: e))
        .toList(growable: growable);
  }

  @override
  Iterable<T> map<T>(T f(E element)) {
    reportRead();
    return _tagValues.map<T>((e) => f(Get.find<E>(tag: e)));
  }

  @override
  E firstWhere(bool test(E element), {E Function()? orElse}) {
    return map((element) => element).firstWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    reportRead();
    return _tagValues.getRange(start, end).map((e) => Get.find<E>(tag: e));
  }

  @override
  E get single {
    if (length == 0) throw const FormatException('NO Element');
    if (length > 1) throw const FormatException('Too Many Elements');
    return this[0];
  }

  @override
  E removeAt(int index) {
    final tag = _tagValues.removeAt(index);
    _binds.remove(tag);
    refresh();
    return Get.find<E>(tag: tag);
  }

  @override
  void retainWhere(bool test(E element)) {
    _tagValues.retainWhere((element) => test(Get.find<E>(tag: element)));
    refresh();
  }

  // set value(List<E> list) {
  //   _tagValues.clear();
  //   addAll(list);
  // }

  @override
  int get length {
    reportRead();
    return _values.length;
  }

  @override
  set length(int newLength) {
    _tagValues.length = newLength;
  }

  // ///慎用
  // ///这个方法是为了提前注册items 将所有items绑定到当前路由
  // ///!!! 会执行items的生命周期,懒加载列表请不要使用
  // List<E> get value {
  //   return _values.toList();
  // }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _tagValues.insertAll(index, iterable.map((e) {
      final tag = item2LogicTag(e);
      _binds.addAll({tag: itemBind(e, tag)});
      return tag;
    }));
    refresh();
  }

  @override
  Iterable<E> get reversed {
    reportRead();
    return _tagValues.reversed.map((e) => Get.find<E>(tag: e));
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    reportRead();
    return _tagValues
        .map((e) {
      final item = Get.find<E>(tag: e);
      if (test(item)) {
        return item;
      } else {
        return null;
      }
    })
        .where((element) => element != null)
        .cast<E>();
  }

  @override
  Iterable<T> whereType<T>() {
    return map((element) => element).whereType<T>();
  }

  @override
  void sort([int compare(E a, E b)?]) {
    _tagValues.sort(
            (a, b) =>
        compare?.call(Get.find<E>(tag: a), Get.find<E>(tag: b)) ?? 0);
    refresh();
  }
}

extension ListExtension<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);

  /// Add [item] to [List<E>] only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  // /// Add [Iterable<E>] to [List<E>] only if [Iterable<E>] is not null.
  // void addAllNonNull(Iterable<E> item) {
  //   if (item != null) addAll(item);
  // }

  /// Add [item] to List<E> only if [condition] is true.
  // void addIf(dynamic condition, E item) {
  //   if (condition is Condition) condition = condition();
  //   if (condition is bool && condition) add(item);
  // }

  // /// Adds [Iterable<E>] to [List<E>] only if [condition] is true.
  // void addAllIf(dynamic condition, Iterable<E> items) {
  //   if (condition is Condition) condition = condition();
  //   if (condition is bool && condition) addAll(items);
  // }

  /// Replaces all existing items of this list with [item]
  void assign(E item) {
    // if (this is RxList) {
    //   (this as RxList)._value;
    // }

    clear();
    add(item);
  }

  /// Replaces all existing items of this list with [items]
  void assignAll(Iterable<E> items) {
    // if (this is RxList) {
    //   (this as RxList)._value;
    // }
    clear();
    addAll(items);
  }
}

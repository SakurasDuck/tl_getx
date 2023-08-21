import 'package:tl_getx/tl_getx.dart';

abstract class GetSController<T> extends GetxController {
  GetSController(T initial) {
    _state = initial;
  }

  late final T _state;

  T get state => _state;
}

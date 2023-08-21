import 'package:get/get.dart';

/// 提供 类似 get it 的 api
extension TlGetEx on GetInterface {
  /// 实现一个 懒加载的 全局单例的 方法
  /// 主要还是提供一个 看起来比较清晰的 api
  void registerLazySingleton<S>(
    InstanceBuilderCallback<S> builder, {
    String? tag,
    bool permanent = true,
  }) {
    Get.lazyPut<S>(builder, tag: tag, fenix: false, permanent: permanent);
  }

  /// 实现类似 get it 的api的封装
  T get<T>({String? tag}) => Get.find<T>(tag: tag);

  ///提供put异步函数的方法
  Future<S> putAsync<S>(AsyncInstanceBuilderCallback<S> asyncBuilder,
          {String? tag, bool permanent = false}) async =>
      Get.put<S>(await asyncBuilder(), tag: tag, permanent: permanent);

  /// 实现一个注册全局异步单例方法
  void registerSingletonAsync<S>(
    AsyncInstanceBuilderCallback<S> builder, {
    String? tag,
  }) {
    registerLazySingleton<Future<S>>(
        () => Get.putAsync(builder, permanent: true, tag: tag),
        tag: tag,
        permanent: false);
  }

  ///获取异步单例方法
  Future<T> findAsync<T>({String? tag}) async {
    if (Get.isRegistered<T>(tag: tag)) {
      return Get.find<T>(tag: tag);
    } else {
      final res = await Get.find<Future<T>>(tag: tag);
      Get.delete<Future<T>>(tag: tag);
      return res;
    }
  }
}

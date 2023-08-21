import 'package:get/get.dart';

import 'config.dart';

mixin GetDataLoading on GetxController {
  final _futures = <VoidAsyncFunction>[];

  final Rx<InitLoadingStatus> _loadingStatus =
  Rx<InitLoadingStatus>(InitLoadingStatus.loading);

  InitLoadingStatus get loadingStatus => _loadingStatus.value;

  List<VoidAsyncFunction> initFutures();


  /// 用于初始化之后还需要刷新状态
  ///
  /// 例如在list refresh();
  void refreshStatus() {
    if (dataIsEmpty != true) {
      _loadingStatus.value = InitLoadingStatus.succeed;
    } else {
      _loadingStatus.value = InitLoadingStatus.data_empty;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _futures.addAll(initFutures());
  }

  @override
  void onReady() {
    super.onReady();
    if (_futures.isEmpty) {
      _loadingStatus.value = InitLoadingStatus.succeed;
    } else {
      Future.wait(_futures.map((e) async => await e.call())).then((value) {
        if (dataIsEmpty != true) {
          _loadingStatus.value = InitLoadingStatus.succeed;
        } else {
          _loadingStatus.value = InitLoadingStatus.data_empty;
        }
      }).catchError((e, stack) {
        _loadingStatus.value = InitLoadingStatus.error;
        //异步抛出错误
        Future.error(e, stack);
      });
    }
  }

  //判断是否为空的状态
  bool get dataIsEmpty => false;
}

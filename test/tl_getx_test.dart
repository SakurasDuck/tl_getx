import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tl_getx/tl_getx.dart';

class Cat {
  static int count = 0;

  static void reset() => count = 0;
  final String name;

  Cat(this.name) {
    count++;
  }
}

void main() {
  setUp(() {
    Get.reset();
    Cat.reset();
  });

  group('tl_get registerLazySingleton', () {
    test('懒加载 且 之创建一次实例', () {
      Get.registerLazySingleton(() => Cat('link'));
      expect(Cat.count, 0); //  延迟初始化
      final c1 = Get.find<Cat>();
      expect(Cat.count, 1); //  延迟初始化

      final c2 = Get.find<Cat>();
      expect(Cat.count, 1);

      /// 只初始化一次
      expect(c1, c2);
    });

    test('当 懒加载的实例 随着页面被删除的时候 该单例还是存在的', () {
      Get.registerLazySingleton<Cat>(() => Cat('link'));
      expect(Cat.count, 0);

      final c1 = Get.get<Cat>();
      expect(Cat.count, 1);

      /// 删除的时候，该实例还存在，除非指定参数 force 为true
      Get.delete<Cat>();
      final c2 = Get.get<Cat>();
      expect(Cat.count, 1);
      expect(c1, c2);
    });

    test('异步注册实例', () async {
      Get.registerSingletonAsync<Cat>(() async {
        await Future.delayed(const Duration(seconds: 3));
        return Cat('Link2');
      });

      print('start find');
      final cat = await Get.findAsync<Cat>();
      expect(cat.name, 'Link2');
    });

    test('异步注册实例 单例 和 懒加载测试', () async {
      Get.registerSingletonAsync<Cat>(() async {
        await Future.delayed(const Duration(seconds: 2));
        return Cat('Link2');
      });

      expect(Cat.count, 0);

      print('start find');
      final cat = await Get.findAsync<Cat>();
      expect(cat.name, 'Link2');

      expect(Cat.count, 1);

      final cat2 = await Get.findAsync<Cat>();
      expect(cat2.name, 'Link2');
      expect(Cat.count, 1);
    });

    test('异步注册实例 验证()async=>Future<S>是否销毁', () async {
      Get.registerSingletonAsync<Cat>(
        () async {
          await Future.delayed(const Duration(seconds: 2));
          return Cat('Link1');
        },
      );

      expect(Cat.count, 0);

      print('start find');
      final cat = await Get.findAsync<Cat>();
      expect(cat.name, 'Link1');

      expect(Cat.count, 1);

      expect(Get.isRegistered<Future<Cat>>(), false);
    });

    test('异步注册实例 测试tag是否生效', () async {
      Get.registerSingletonAsync<Cat>(
        () async {
          await Future.delayed(const Duration(seconds: 2));
          return Cat('Link1');
        },
      );

      Get.registerSingletonAsync<Cat>(() async {
        await Future.delayed(const Duration(seconds: 2));
        return Cat('Link2');
      }, tag: '1');

      expect(Cat.count, 0);

      print('start find');
      final cat = await Get.findAsync<Cat>();
      expect(cat.name, 'Link1');

      expect(Cat.count, 1);

      final cat2 = await Get.findAsync<Cat>(tag: '1');
      expect(cat2.name, 'Link2');
      expect(Cat.count, 2);
    });

    test('异步注册实例 验证同时findAsync保证为单例,不是getFuture()多次', () async {
      Get.registerSingletonAsync<Cat>(() async {
        print('cat init');
        await Future.delayed(const Duration(seconds: 2));
        return Cat('Link2');
      });
      final futures = <Future<Cat>>[];
      futures.add(Get.findAsync<Cat>());
      futures.add(Get.findAsync<Cat>());
      futures.add(Get.findAsync<Cat>());
      await Future.wait(futures);
      expect(Cat.count, 1);

      ///为什么不会执行多次Future<T>(),原因是putAsync是个同步过程,多次同时findAsync是拿到的是同一个对象
      /// 参考执行流程日志
      ///
      /// findAsync1
      /// putAsync
      /// putFuture
      /// cat init
      /// end putAsync (重点)
      /// findAsync 2
      /// findAsync 3
      /// end putFuture
      /// end findAsync 1
      /// end findAsync 2
      /// end findAsync 3
    });
  });
}

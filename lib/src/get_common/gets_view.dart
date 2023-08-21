import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gets_controller.dart';

abstract class GetSView<K,T extends GetSController<K>> extends GetView<T> {
   const GetSView({this.tag, Key? key}) :super(key: key);

  K get state => controller.state;

  @override
  final String? tag;

}

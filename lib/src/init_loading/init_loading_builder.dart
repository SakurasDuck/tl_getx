import 'package:flutter/material.dart';

import 'config.dart';

class InitLoading extends StatelessWidget {
  const InitLoading({required this.status,
    required this.succeedBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    Key? key})
      : super(key: key);

  final InitLoadingStatus status;

  final WidgetBuilder succeedBuilder;

  final WidgetBuilder? loadingBuilder;

  final WidgetBuilder? errorBuilder;

  final WidgetBuilder? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    if (status == InitLoadingStatus.loading) {
      return loadingBuilder?.call(context) ?? succeedBuilder.call(context);
    } else if (status == InitLoadingStatus.error) {
      return errorBuilder?.call(context) ?? succeedBuilder.call(context);
    } else if (status == InitLoadingStatus.data_empty) {
      return emptyBuilder?.call(context) ?? succeedBuilder.call(context);
    } else {
      return succeedBuilder.call(context);
    }
  }
}

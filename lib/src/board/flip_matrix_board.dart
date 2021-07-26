import 'dart:async';

import 'package:flutter/material.dart';

import '../widget/flip_widget.dart';
import 'flip_matrix_board_builder.dart';

class FlipMatrixBoardSingleChild extends StatelessWidget {
  FlipMatrixBoardSingleChild({
    Key? key,
    required Widget child,
    required Axis axis,
    required double width,
    required double height,
    required int columnCount,
    required int rowCount,
    int minAnimationMillis = 500,
    int maxAnimationMillis = 1500,
    int maxDelayMillis = 2500,
    Color backgroundColor = Colors.white,
  })  : _builder = SingleChildFlipMatrixBoardBuilder(
          child: child,
          axis: axis,
          width: width,
          height: height,
          columnCount: columnCount,
          rowCount: rowCount,
          minAnimationMillis: minAnimationMillis,
          maxAnimationMillis: maxAnimationMillis,
          maxDelayMillis: maxDelayMillis,
          backgroundColor: backgroundColor,
        ),
        super(key: key);

  FlipMatrixBoardSingleChild.assetImage({
    Key? key,
    required String imageName,
    required Axis axis,
    required double width,
    required double height,
    required int columnCount,
    required int rowCount,
    Color backgroundColor = Colors.white,
    int minAnimationMillis = 500,
    int maxAnimationMillis = 1500,
    int maxDelayMillis = 2500,
  }) : this(
          child: Image.asset(
            imageName,
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
          axis: axis,
          width: width,
          height: height,
          columnCount: columnCount,
          rowCount: rowCount,
          minAnimationMillis: minAnimationMillis,
          maxAnimationMillis: maxAnimationMillis,
          maxDelayMillis: maxDelayMillis,
          backgroundColor: backgroundColor,
        );

  final SingleChildFlipMatrixBoardBuilder _builder;

  @override
  Widget build(BuildContext context) => _builder.build(context);
}

class FlipMatrixBoardStream<T> extends StatefulWidget {
  const FlipMatrixBoardStream({
    Key? key,
    this.initialValue,
    required this.itemStream,
    required this.itemBuilder,
    required this.axis,
    required this.width,
    required this.height,
    required this.columnCount,
    required this.rowCount,
    this.minAnimationMillis = 500,
    this.maxAnimationMillis = 1500,
    this.maxDelayMillis = 2500,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final T? initialValue;
  final Stream<T> itemStream;
  final ItemBuilder<T> itemBuilder;

  final Axis axis;
  final double width;
  final double height;
  final int columnCount;
  final int rowCount;
  final int minAnimationMillis;
  final int maxAnimationMillis;
  final int maxDelayMillis;
  final Color backgroundColor;

  @override
  _FlipMatrixBoardStreamState<T> createState() =>
      _FlipMatrixBoardStreamState<T>();
}

class _FlipMatrixBoardStreamState<T> extends State<FlipMatrixBoardStream<T>> {
  final _controller = StreamController<T>.broadcast();
  late final StreamSubscription<T> _subscription;
  late final StreamFlipMatrixBoardBuilder<T> _builder;

  @override
  void initState() {
    super.initState();

    _builder = StreamFlipMatrixBoardBuilder<T>(
      initialValue: widget.initialValue,
      itemStream: _controller.stream,
      itemBuilder: widget.itemBuilder,
      axis: widget.axis,
      width: widget.width,
      height: widget.height,
      columnCount: widget.columnCount,
      rowCount: widget.rowCount,
      minAnimationMillis: widget.minAnimationMillis,
      maxAnimationMillis: widget.maxAnimationMillis,
      maxDelayMillis: widget.maxDelayMillis,
      backgroundColor: widget.backgroundColor,
    );

    _subscription = widget.itemStream.listen(_onNewItem);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.close();
    super.dispose();
  }

  void _onNewItem(T value) => _controller.add(value);

  @override
  Widget build(BuildContext context) => _builder.build(context);
}
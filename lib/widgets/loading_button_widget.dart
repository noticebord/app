import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/material.dart';

class LoadingButtonWidget extends StatefulWidget {
  final bool loading;
  final Widget child;
  final bool elevated;
  final VoidCallback? onPressed;
  const LoadingButtonWidget({
    Key? key,
    required this.loading,
    required this.child,
    this.elevated = true,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingButtonWidgetState();
  }
}

class _LoadingButtonWidgetState extends State<LoadingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.loading
          ? const LoaderWidget()
          : widget.elevated
              ? ElevatedButton(
                  onPressed: widget.onPressed,
                  child: widget.child,
                )
              : TextButton(
                  onPressed: widget.onPressed,
                  child: widget.child,
                ),
    );
  }
}

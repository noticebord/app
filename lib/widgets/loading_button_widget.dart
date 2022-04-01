import 'package:app/widgets/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButtonWidget extends StatefulWidget {
  final bool loading;
  final Widget? child;
  final VoidCallback? onPressed;
  const LoadingButtonWidget({Key? key, required this.loading, required this.child, this.onPressed,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingButtonWidgetState();
  }
}

class _LoadingButtonWidgetState extends State<LoadingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.loading
          ? const LoaderWidget()
          : ElevatedButton(
              onPressed: widget.onPressed,
              child: widget.child,
            ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButtonWidget extends StatefulWidget {
  final bool loading;
  final VoidCallback? onPressed;
  const LoadingButtonWidget({Key? key, required this.loading, this.onPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingButtonWidgetState();
  }
}

class _LoadingButtonWidgetState extends State<LoadingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.loading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: widget.onPressed,
              child: const Text("Load more"),
            ),
    );
  }
}

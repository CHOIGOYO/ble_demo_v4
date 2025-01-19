import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseLayout extends ConsumerStatefulWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends ConsumerState<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

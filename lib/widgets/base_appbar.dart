import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BaseAppbar extends ConsumerStatefulWidget {
  final String title;
  const BaseAppbar({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseAppbarState();
}

class _BaseAppbarState extends ConsumerState<BaseAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: widget.title != 'BLE DEMO V4'
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (widget.title != 'BLE DEMO V4')
            IconButton(
              iconSize: 20,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
          Spacer(),
          Text(widget.title, style: TextStyle(fontSize: 16, height: 3)),
          Spacer(),
        ],
      ),
    );
  }
}

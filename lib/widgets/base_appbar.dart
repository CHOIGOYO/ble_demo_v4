import 'package:ble_demo_v4/provider/connected_dev_prov.dart';
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
    bool isHome = widget.title != 'BLE DEMO V4';
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
        mainAxisAlignment:
            isHome ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          if (isHome)
            IconButton(
              iconSize: 20,
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                await ref
                    .read(connectedDevProvProvider)!
                    .device
                    .disconnect()
                    .then((_) {
                  ref.read(connectedDevProvProvider.notifier).clear();
                  context.pop();
                });
              },
            ),
          Spacer(),
          Container(
              margin: EdgeInsets.only(right: isHome ? 35 : 0),
              child: Text(widget.title,
                  style: TextStyle(fontSize: 16, height: 3))),
          Spacer(),
        ],
      ),
    );
  }
}

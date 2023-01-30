import 'package:flutter/material.dart';

class ToolboxPage extends StatefulWidget {
  const ToolboxPage({super.key});

  @override
  State<ToolboxPage> createState() => _ToolboxPageState();
}

class _ToolboxPageState extends State<ToolboxPage>
    with AutomaticKeepAliveClientMixin<ToolboxPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Toolbox Page"),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

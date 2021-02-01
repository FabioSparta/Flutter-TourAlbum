import 'package:flutter/material.dart';
import 'global_vars.dart' as gv;

class FullScreenPage extends StatefulWidget {
  FullScreenPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => new _FullScreenPage();
}

class _FullScreenPage extends State<FullScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    widget = Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(gv.image_url),
        ),
      ),
    );

    return new Scaffold(
      appBar: _buildBar(context),
      body: widget,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title:
          const Text('Fullscreen Image', style: TextStyle(color: Colors.blue)),
      centerTitle: true,
    );
  }
}

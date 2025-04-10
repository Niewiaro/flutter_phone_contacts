import 'package:flutter/material.dart';

class SingleContactInList extends StatelessWidget {
  final String _name;
  final CircleAvatar _photoWidget;
  final String _number;

  const SingleContactInList(
    this._name,
    this._photoWidget,
    this._number, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _photoWidget,
      title: Text(_name),
      subtitle: Text(_number),
    );
  }
}

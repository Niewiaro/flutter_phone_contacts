import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_contacts/single_contact_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _permissionDenied = false;
  List<Contact>? _contacts;

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() {
        _permissionDenied = true;
      });
    } else {
      // final contacts = await FlutterContacts.getContacts(); // just name
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
          _permissionDenied
              ? const Center(child: Text("Permission denied"))
              : (_contacts == null)
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _contacts!.length,
                itemBuilder: (context, index) {
                  Uint8List? photo = _contacts![index].photo;
                  String number =
                      (_contacts![index].phones.isNotEmpty)
                          ? (_contacts![index].phones.first.number)
                          : "--";
                  return SingleContactInList(
                    _contacts![index].displayName,
                    (_contacts![index].photo == null)
                        ? const CircleAvatar(child: Icon(Icons.person))
                        : CircleAvatar(backgroundImage: MemoryImage(photo!)),
                    number,
                  );
                },
              ),
    );
  }
}

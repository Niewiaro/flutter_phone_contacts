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
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() {
        _permissionDenied = true;
      });
    } else {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
      });
    }
  }

  void _filterContacts(String query) {
    if (_contacts == null) return;

    final sanitizedQuery = query.toLowerCase().replaceAll(' ', '');

    setState(() {
      _filteredContacts =
          _contacts!.where((contact) {
            final name = contact.displayName.toLowerCase();
            final number =
                contact.phones.isNotEmpty
                    ? contact.phones.first.number.replaceAll(' ', '')
                    : '';

            return name.contains(sanitizedQuery) ||
                number.contains(sanitizedQuery);
          }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(() {
      _filterContacts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 4,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.contacts, size: 28),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body:
          _permissionDenied
              ? const Center(child: Text("Permission denied"))
              : (_contacts == null)
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          final photo = contact.photo;
                          final number =
                              contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : "-";

                          return SingleContactInList(
                            contact.displayName,
                            (photo == null)
                                ? const CircleAvatar(child: Icon(Icons.person))
                                : CircleAvatar(
                                  backgroundImage: MemoryImage(photo),
                                ),
                            number,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(16),
                        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterContacts,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterContacts('');
                                FocusScope.of(context).unfocus();
                              },
                            )
                                : null,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          ),
                          style: const TextStyle(fontFamily: 'Raleway'),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
    );
  }
}

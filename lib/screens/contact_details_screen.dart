import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsScreen extends StatelessWidget {
  final String name;
  final String number;
  final CircleAvatar avatar;

  const ContactDetailsScreen({
    Key? key,
    required this.name,
    required this.number,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 5,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 26),
              const SizedBox(width: 8),
              Text(
                'Kontakt',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 170,
                height: 170,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(child: avatar),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 10,
                shadowColor: color.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: color, width: 1.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 28,
                  ),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Card(
                elevation: 8,
                shadowColor: color.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: color.withOpacity(0.6), width: 1.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 26,
                  ),
                  child: Text(
                    number,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Raleway',
                      fontSize: 21,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.95),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.phone, size: 36),
                onPressed: () async {
                  final uri = Uri(scheme: 'tel', path: number);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Can not call...')),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  shape: MaterialStatePropertyAll(const CircleBorder()),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
                  elevation: const MaterialStatePropertyAll(6),
                  shadowColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.message, size: 36),
                onPressed: () async {
                  final uri = Uri(scheme: 'sms', path: number);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nie można wysłać SMS')),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  shape: MaterialStatePropertyAll(const CircleBorder()),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
                  elevation: const MaterialStatePropertyAll(6),
                  shadowColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

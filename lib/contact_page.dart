import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_gradient_background.dart';

/// Adresse qui recevra les messages (remplacez par la vôtre).
const String kContactEmailDestinataire = 'vmgilles853@gmail.com';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _mailController;
  late final TextEditingController _messageController;

  /// Texte tapé lisible sur fond blanc (le thème utilise onSurface clair ailleurs).
  static const TextStyle _styleSaisieChamp = TextStyle(
    color: Color(0xFF1A1A1A),
    fontSize: 16,
  );

  static InputDecoration _champ(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _mailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _mailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _validerNonVide(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez indiquer $label.';
    }
    return null;
  }

  String? _validerEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Veuillez indiquer votre e-mail.';
    if (!v.contains('@') || !v.contains('.')) {
      return 'E-mail invalide.';
    }
    return null;
  }

  String _corpsMessage() {
    return '''
Nom : ${_nomController.text.trim()}
Prénom : ${_prenomController.text.trim()}
E-mail : ${_mailController.text.trim()}

Message :
${_messageController.text.trim()}
''';
  }

  Future<void> _envoyerParMail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final uri = Uri(
      scheme: 'mailto',
      path: kContactEmailDestinataire,
      queryParameters: <String, String>{
        'subject': 'Message depuis l’application',
        'body': _corpsMessage(),
      },
    );

    try {
      final ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Votre messagerie s’ouvre : envoyez le message pour nous le transmettre.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Impossible d’ouvrir l’application e-mail. Vérifiez qu’une messagerie est configurée.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ouvrir l’application e-mail.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      appBar: AppBar(title: const Text('Contact')),
      body: PurpleGradientBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Nous sommes à votre disposition pour tout besoin en informatique. Laissez-nous un message.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _nomController,
                        style: _styleSaisieChamp,
                        cursorColor: Color(0xFF4A148C),
                        decoration: _champ('Nom'),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => _validerNonVide(v, 'votre nom'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _prenomController,
                        style: _styleSaisieChamp,
                        cursorColor: Color(0xFF4A148C),
                        decoration: _champ('Prénom'),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => _validerNonVide(v, 'votre prénom'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _mailController,
                        style: _styleSaisieChamp,
                        cursorColor: Color(0xFF4A148C),
                        decoration: _champ('E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: _validerEmail,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _messageController,
                        style: _styleSaisieChamp,
                        cursorColor: Color(0xFF4A148C),
                        decoration: _champ('Message'),
                        minLines: 3,
                        maxLines: 6,
                        validator: (v) => _validerNonVide(v, 'un message'),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4A148C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _envoyerParMail,
                        child: const Text('Envoyer par e-mail'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

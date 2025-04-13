import 'package:flutter/material.dart';

void main() {
  runApp(const MorseApp());
}

class MorseApp extends StatelessWidget {
  const MorseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App: Texto a Código Morse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MorseHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MorseHomePage extends StatefulWidget {
  const MorseHomePage({super.key});

  @override
  State<MorseHomePage> createState() => _MorseHomePageState();
}

class _MorseHomePageState extends State<MorseHomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _morseController = TextEditingController();

  bool _isClearButtonActive = false;

  final Map<String, String> _morseCode = {
    'A': '.-', 
    'B': '-...', 
    'C': '-.-.', 
    'D': '-..', 
    'E': '.', 
    'F': '..-.',
    'G': '--.', 
    'H': '....', 
    'I': '..', 
    'J': '.---', 
    'K': '-.-', 
    'L': '.-..',
    'M': '--', 
    'N': '-.', 
    'O': '---', 
    'P': '.--.', 
    'Q': '--.-', 
    'R': '.-.',
    'S': '...', 
    'T': '-', 
    'U': '..-', 
    'V': '...-', 
    'W': '.--', 
    'X': '-..-',
    'Y': '-.--', 
    'Z': '--..', 
    '1': '.----', 
    '2': '..---', 
    '3': '...--',
    '4': '....-', 
    '5': '.....', 
    '6': '-....', 
    '7': '--...', 
    '8': '---..',
    '9': '----.', 
    '0': '-----', 
    ' ': '/'
  };

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateClearButtonState);
    _morseController.addListener(_updateClearButtonState);
  }

  @override
  void dispose() {
    _textController.dispose();
    _morseController.dispose();
    super.dispose();
  }

  void _updateClearButtonState() {
    setState(() {
      _isClearButtonActive =
          _textController.text.isNotEmpty || _morseController.text.isNotEmpty;
    });
  }

  String _textToMorse(String text) {
    final invalidChars = text
        .toUpperCase()
        .split('')
        .where((char) => !_morseCode.containsKey(char))
        .toList();

    if (invalidChars.isNotEmpty) {
      _showError('Caracteres no válidos: ${invalidChars.join(', ')}');
      return '';
    }

    return text
        .toUpperCase()
        .split('')
        .map((char) => _morseCode[char] ?? '')
        .join(' ');
  }

  String _morseToText(String morse) {
    if (morse.trim().isEmpty) {
      return ''; 
    }

    final reversedMorseCode = _morseCode.map((key, value) => MapEntry(value, key));
    final invalidCodes = morse
        .split(' ')
        .where((code) => !reversedMorseCode.containsKey(code))
        .toList();

    if (invalidCodes.isNotEmpty) {
      _showError('Códigos Morse no válidos: ${invalidCodes.join(', ')}');
      return '';
    }

    return morse
        .split(' ')
        .map((code) => reversedMorseCode[code] ?? '')
        .join('');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _clearFields() {
    setState(() {
      _textController.clear();
      _morseController.clear();
      _isClearButtonActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Texto a Código Morse',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¿Qué es esta aplicación?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta aplicación convierte texto a código Morse y viceversa. Es útil para aprender Morse, enviar mensajes codificados o simplemente experimentar con este sistema de comunicación.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Cómo usarla?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Escribe texto en el primer campo para convertirlo a código Morse.\n'
                '2. Escribe código Morse en el segundo campo para convertirlo a texto.\n'
                '3. Usa el botón "Limpiar" para borrar ambos campos.\n',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Texto',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (text) {
                  setState(() {
                    _morseController.text = _textToMorse(text);
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _morseController,
                decoration: InputDecoration(
                  labelText: 'Código Morse',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (morse) {
                  setState(() {
                    _textController.text = _morseToText(morse);
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isClearButtonActive ? _clearFields : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isClearButtonActive ? Colors.red : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Limpiar',
                  style: TextStyle(
                    color: _isClearButtonActive ? Colors.white : Colors.black,
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
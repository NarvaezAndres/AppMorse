// Paquete de flutter que contiene widgets y herramientas para construir interfaces graficas.
import 'package:flutter/material.dart';

// Punto de entrada de la aplicación.
void main() {
  // Función para mostrar el widget principal 'MorseApp'.
  runApp(const MorseApp()); // 
}

// Clase principal de la aplicación.
class MorseApp extends StatelessWidget { // StatelesWidget indica que este widget no tiene estado mutable.
  // Constructor de la clase.
  const MorseApp({super.key}); // super.key le indica a flutter que este widget es único.

  // Configuración del widget.
  @override
  // Metodo que construye la interfaz gráfica del widget.
  Widget build(BuildContext context) {
    return MaterialApp( // widget que configura la aplicación, define titulo, tema, etc de la app.
      title: 'App: Texto a Código Morse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MorseHomePage(), //Especifica la pantalla inicial de la aplicación.
      debugShowCheckedModeBanner: false,
    );
  }
}

// Widget que representa la pantalla principal.
class MorseHomePage extends StatefulWidget { //StatefulWidget indica que este tiene un estado mutable.
  const MorseHomePage({super.key});

  @override
  State<MorseHomePage> createState() => _MorseHomePageState(); // createState() crea una instancia de la clase _morseHomePageState.
}

//Clase del estado de la pantalla principal
class _MorseHomePageState extends State<MorseHomePage> { // Clase que contiene el estado del widget MorseHomePage. Aquí se definira la lógica y los datos que cambian durante la ejecución.
  // Controla el texto de los campos de texto.
  final TextEditingController _textController = TextEditingController(); // Controlar el campo de texto normal.
  final TextEditingController _morseController = TextEditingController(); // Controlat el campo de texto para código Morse.

  // Variable que indica si el botón limpiar debe estar activo (rojo) o inactivo (blanco).
  bool _isClearButtonActive = false;

  // Mapa de caracteres Morse
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

  // Metodos del ciclo de vida.
  @override
  void initState() { // Metodo que se ejecuta cuando el widget se inicializa.
    super.initState();
    // addListener() metodo que permite escuchar los cambios de los campos de texto y actualiza el estado del bóton limpiar.
    _textController.addListener(_updateClearButtonState);
    _morseController.addListener(_updateClearButtonState);
  }

  // Metodo que se ejecuta cuando el widget se elimina.
  @override
  void dispose() {
    _textController.dispose();
    _morseController.dispose();
    super.dispose();
  }

  //Actualización del botón limpiar.
  void _updateClearButtonState() { // updateClearButtonState() Actualiza el estado del botón limpiar dependiendo de si hay texto en los campos.
    setState(() {
      _isClearButtonActive =
          _textController.text.isNotEmpty || _morseController.text.isNotEmpty;
    });
  }

  // Conversión de texto a Morse.
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

  // Conversión de Morse a Texto.
  String _morseToText(String morse) {
    // Si el campo está vacío o contiene solo espacios, no hara nada.
    if (morse.trim().isEmpty) {
      return '';
    }

    // Se crea un mapa invertido para buscar caracteres por código Morse.
    final reversedMorseCode = _morseCode.map((key, value) => MapEntry(value, key));

    // Dividir el código Morse en partes y eliminar espacios vacíos.
    final morseParts = morse.split(' ').where((code) => code.isNotEmpty).toList();

    // Verificar si hay códigos Morse no válidos.
    final invalidCodes = morseParts.where((code) => !reversedMorseCode.containsKey(code)).toList();

    // Si hay códigos no válidos, mostrar un error.
    if (invalidCodes.isNotEmpty) {
      _showError('Códigos Morse no válidos: ${invalidCodes.join(', ')}');
      return '';
    }

    // Convertir el código Morse a texto.
    return morseParts.map((code) => reversedMorseCode[code] ?? '').join('');
  }

  // Mostrar errores.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Limpiar campos.
  void _clearFields() {
    setState(() {
      _textController.clear();
      _morseController.clear();
      _isClearButtonActive = false;
    });
  }

  // Construcción de la interfaz.
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
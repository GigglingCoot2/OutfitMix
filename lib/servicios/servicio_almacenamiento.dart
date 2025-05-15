import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final String _topsKey = 'imagenes_tops';
  final String _bottomsKey = 'imagenes_bottoms';

  Future<void> guardarImagen(String tipo, File imagen) async {
    final prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();

    final nombreArchivo = '${DateTime.now().millisecondsSinceEpoch}_${imagen.path.split('/').last}';
    final nuevoArchivo = await imagen.copy('${directory.path}/$nombreArchivo');

    List<String> rutas = prefs.getStringList(_getKey(tipo)) ?? [];
    rutas.add(nuevoArchivo.path);
    await prefs.setStringList(_getKey(tipo), rutas);
  }

  Future<List<String>> cargarTops() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_topsKey) ?? [];
  }

  Future<List<String>> cargarBottoms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bottomsKey) ?? [];
  }

  String _getKey(String tipo) {
    if (tipo == 'top') return _topsKey;
    if (tipo == 'bottom') return _bottomsKey;
    throw Exception('Tipo inválido');
  }
}


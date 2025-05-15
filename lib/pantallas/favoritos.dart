import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<List<String>> _outfitsFavoritos = [];

  @override
  void initState() {
    super.initState();
    cargarFavoritos();
  }

  Future<void> cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('outfits_favoritos') ?? [];
    final outfits = lista.map((e) {
      final parts = e.split('|');
      if (parts.length == 2) {
        return [parts[0], parts[1]];
      }
      return null;
    }).whereType<List<String>>().toList();

    setState(() {
      _outfitsFavoritos = outfits;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_outfitsFavoritos.isEmpty) {
      return const Center(child: Text('No hay outfits favoritos'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _outfitsFavoritos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 outfits por fila
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final outfit = _outfitsFavoritos[index];
        return Card(
          elevation: 2,
          child: Column(
            children: outfit
                .map(
                  (imgPath) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  // Como se guarda en rutas locales, se usa Image.file
                  child: Image.file(File(imgPath), fit: BoxFit.cover),
                ),
              ),
            )
                .toList(),
          ),
        );
      },
    );
  }
}

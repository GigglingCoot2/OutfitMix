import 'package:flutter/material.dart';
import 'package:pmovil/servicios/servicio_almacenamiento.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class PantallaInicioContenido extends StatefulWidget {
  const PantallaInicioContenido({Key? key}) : super(key: key);

  @override
  State<PantallaInicioContenido> createState() => _PantallaInicioContenidoState();
}

class _PantallaInicioContenidoState extends State<PantallaInicioContenido> {
  bool mostrarArmado = false;

  List<String> tops = ['assets/images/top1.jpg', 'assets/images/top2.jpg'];
  List<String> bottoms = ['assets/images/bottom1.jpg', 'assets/images/bottom2.jpg'];

  int topIndex = 0;
  int bottomIndex = 0;

  Future<void> guardarOutfitEnFavoritos(String top, String bottom) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('outfits_favoritos') ?? [];
    lista.add('$top|$bottom');
    await prefs.setStringList('outfits_favoritos', lista);
  }


  @override
  void initState() {
    super.initState();
    cargarPrendasLocales();
  }

  Future<void> cargarPrendasLocales() async {
    final storage = StorageService();
    final topsLocales = await storage.cargarTops();
    final bottomsLocales = await storage.cargarBottoms();

    setState(() {
      tops.addAll(topsLocales);
      bottoms.addAll(bottomsLocales);
    });
  }

  void cambiarTop(int direccion) {
    setState(() {
      topIndex = (topIndex + direccion) % tops.length;
      if (topIndex < 0) topIndex += tops.length;
    });
  }

  void cambiarBottom(int direccion) {
    setState(() {
      bottomIndex = (bottomIndex + direccion) % bottoms.length;
      if (bottomIndex < 0) bottomIndex += bottoms.length;
    });
  }

  void aleatorioTops() {
    setState(() {
      topIndex = (topIndex + 1) % tops.length;
    });
  }

  void aleatorioBotoms() {
    setState(() {
      bottomIndex = (bottomIndex + 1) % bottoms.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mostrarArmado) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              mostrarArmado = true;
            });
          },
          child: const Text('Arma tu outfit')
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildControlDeCategoria(tops[topIndex], () => cambiarTop(-1), aleatorioTops, () => cambiarTop(1)),
        const SizedBox(height: 20),
        buildControlDeCategoria(bottoms[bottomIndex], () => cambiarBottom(-1), aleatorioBotoms, () => cambiarBottom(1)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.star_border),
              onPressed: ()async {
                // Guardar como favorito
                await guardarOutfitEnFavoritos(tops[topIndex], bottoms[bottomIndex]);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Outfit agregado a favoritos')),
                );
              },
            ),
          ],
        )
      ],
    );
  }

  Widget buildControlDeCategoria(String imagePath, VoidCallback onPrev, VoidCallback onRandom, VoidCallback onNext) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_left), onPressed: onPrev),
            ElevatedButton(
              onPressed: onRandom,
              child: const Text('Random'),
            ),
            IconButton(icon: const Icon(Icons.arrow_right), onPressed: onNext),
          ],
        ),
        const SizedBox(height: 10),
        Image(
          image: imagePath.startsWith('assets/')
              ? AssetImage(imagePath)
              : FileImage(File(imagePath)) as ImageProvider,
          height: 120,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}


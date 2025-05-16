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
  List<String> bottoms = [
    'assets/images/bottom1.jpg',
    'assets/images/bottom2.jpg'
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fall fashion'),
        centerTitle: true,
      ),
      body: Center(
        child: mostrarArmado
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildControlDeCategoria(
                tops[topIndex], () => cambiarTop(-1), aleatorioTops, () =>
                cambiarTop(1)),
            const SizedBox(height: 20),
            buildControlDeCategoria(
                bottoms[bottomIndex], () => cambiarBottom(-1),
                aleatorioBotoms, () => cambiarBottom(1)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () async {
                    await guardarOutfitEnFavoritos(
                        tops[topIndex], bottoms[bottomIndex]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Outfit agregado a favoritos')),
                    );
                  },
                ),
              ],
            ),
          ],
        )
            : ElevatedButton(
          onPressed: () {
            setState(() {
              mostrarArmado = true;
            });
          },
          child: const Text('Arma tu outfit'),
        ),
      ),
    );
  }

  Widget buildControlDeCategoria(
      String imagePath,
      VoidCallback onPrev,
      VoidCallback onRandom,
      VoidCallback onNext,
      ) {
    ImageProvider imageProvider;

    if (imagePath.contains('assets/')) {
      imageProvider = AssetImage(imagePath);
    } else {
      imageProvider = FileImage(File(imagePath));
    }

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
          image: imagePath.contains('assets/')
              ? AssetImage(imagePath)
              : FileImage(File(imagePath)),
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 120, color: Colors.grey);
          },
        )
      ],
    );
  }
}


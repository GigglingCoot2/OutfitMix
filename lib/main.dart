import 'package:flutter/material.dart';
import 'pantallas/pantalla_inicio.dart';
import 'pantallas/cargar_prendas.dart';
import 'pantallas/favoritos.dart';

void main() {
  runApp(const OutfitMix());
}

class OutfitMix extends StatelessWidget {
  const OutfitMix({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OutfitMix',
      theme: ThemeData(
        fontFamily: 'AdLib',
        primarySwatch: Colors.lightBlue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        brightness: Brightness.light,
        
      ),
      home: const PantallaInicio(title: 'Pantalla Inicio OutfitMix'),
    );
  }
}

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key, required this.title});

  final String title;

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int currentPageIndex = 0;

  final List<Widget> _pantallas = const [
    PantallaInicioContenido(),
    CargarPrendas(),
    Favoritos(),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.pink.shade50,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.pinkAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'Cargar Prenda',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.star),
            icon: Icon(Icons.star_border_outlined),
            label: 'Favoritos',
          ),
        ],
      ),
      body: _pantallas[currentPageIndex],
    );
  }
}

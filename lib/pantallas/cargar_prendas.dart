import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CargarPrendas extends StatefulWidget {
  const CargarPrendas({super.key});

  @override
  State<CargarPrendas> createState() => _CargarPrendasState();
}

class _CargarPrendasState extends State<CargarPrendas> {
  String? categoriaSeleccionada;
  final ImagePicker picker = ImagePicker();

  // Precargadas
  final List<String> topsDefault = [
    'assets/images/top1.jpg',
    'assets/images/top2.jpg',
  ];
  final List<String> bottomsDefault = [
    'assets/images/bottom1.jpg',
    'assets/images/bottom2.jpg',
  ];

  // Cargadas por el usuario
  final List<File> topsCargadas = [];
  final List<File> bottomsCargadas = [];

  Future<void> seleccionarDesdeGaleria() async {
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null && categoriaSeleccionada != null) {
      setState(() {
        if (categoriaSeleccionada == 'Top') {
          topsCargadas.add(File(imagen.path));
        } else if (categoriaSeleccionada == 'Bottom') {
          bottomsCargadas.add(File(imagen.path));
        }
      });
    }
  }

  List<Widget> mostrarImagenes(String categoria) {
    final List<Widget> widgets = [];

    if (categoria == 'Top') {
      widgets.addAll(topsDefault.map((path) => Image.asset(path, height: 100)));
      widgets.addAll(topsCargadas.map((file) => Image.file(file, height: 100)));
    } else if (categoria == 'Bottom') {
      widgets.addAll(bottomsDefault.map((path) => Image.asset(path, height: 100)));
      widgets.addAll(bottomsCargadas.map((file) => Image.file(file, height: 100)));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: const Text('Selecciona categoría'),
            value: categoriaSeleccionada,
            items: const [
              DropdownMenuItem(value: 'Top', child: Text('Top')),
              DropdownMenuItem(value: 'Bottom', child: Text('Bottom')),
            ],
            onChanged: (value) {
              setState(() {
                categoriaSeleccionada = value;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: seleccionarDesdeGaleria,
            child: const Text('Seleccionar desde galería'),
          ),
          const SizedBox(height: 20),
          const Text(
            '**De preferencia que las fotos sean lo más limpias posibles para una mejor experiencia.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          if (categoriaSeleccionada != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: mostrarImagenes(categoriaSeleccionada!),
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/paint/dotted_border.dart';

class BoxedImageView extends StatelessWidget {
  final List<Widget>? widgetForDetailsColumn;
  final Pokemon pokemon;

  const BoxedImageView(
      {super.key, this.widgetForDetailsColumn, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.white30 : Colors.black87;
    
    var typesList = ["unknown"];
    if (pokemon.types.isNotEmpty) {
      typesList = pokemon.types;
    }
    LinearGradient? l = pokemon.types.length > 1
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                for (String x in typesList) PokemonColors.getColorByType(x, isDarkMode: isDarkMode)
              ])
        : null;
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: l,
        color: PokemonColors.getColorByType(typesList.first, isDarkMode: isDarkMode),
        border: DottedBorder(
            dashSpace: 6,
            borderRadius: 10,
            strokeWidth: 1.2,
            dashPattern: 5,
            color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
              fit: BoxFit.fitWidth,
              height: 60,
            ),
          ),
          ...widgetForDetailsColumn ?? []
        ],
      ),
    );
  }
}

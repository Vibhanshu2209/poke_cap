import 'package:poke_cap/global_exports.dart';

class ColoredChip extends StatelessWidget {
  const ColoredChip({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.white30 : Colors.black;
    final chipColor = PokemonColors.getColorByType(value, isDarkMode: isDarkMode);
    
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: chipColor,
          border: Border.all(color: borderColor, width: 1.2)),
      child: value.capitalizeFirstLetter().tw().padX(8).padY(4),
    );
  }
}

import 'package:poke_cap/global_exports.dart';

class ColoredChip extends StatelessWidget {
  const ColoredChip({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: PokemonColors.getColorByType(value),
          border: Border.all(color: Colors.black, width: 1.2)),
      child: value.capitalizeFirstLetter().tw().padX(8).padY(4),
    );
  }
}

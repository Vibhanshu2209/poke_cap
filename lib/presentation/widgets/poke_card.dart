import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/widgets/boxed_image_view.dart';
import '../../domain/models/pokemon.dart';

class PokeCardItem extends StatelessWidget {
  final Pokemon pokemon;
  final bool newStyleWidget;
  final bool showNameAndId;

  const PokeCardItem(
      {super.key,
      required this.pokemon,
      this.newStyleWidget = false,
      this.showNameAndId = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (pokemon.name != "") {
            context.push('/pokemonDetails/${pokemon.id}', extra: pokemon);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: "Details for this pokemon is not available yet".tw()));
          }
        },
        child: newStyleWidget
            ? newStyle(pokemon)
            : standardStyle(pokemon, showNameAndId));
  }

  Widget standardStyle(Pokemon pokemon, bool showNameAndId) {
    return BoxedImageView(
        pokemon: pokemon,
        widgetForDetailsColumn:
            showNameAndId ? showNameAndIDWidget(pokemon) : []);
  }

  Widget newStyle(Pokemon pokemon) {
    return Stack(
      children: [
        BoxedImageView(
          pokemon: pokemon,
          widgetForDetailsColumn: [showNameAndIDWidget(pokemon).first],
        ),
        Positioned(
          left: -4,
          top: -24,
          child: "${pokemon.id}".tw(fontSize: 70),
        ),
      ],
    );
  }
}

List<Widget> showNameAndIDWidget(Pokemon pokemon) {
  return [
    Text(
      pokemon.name,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    Text(
      "00${pokemon.id}",
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ];
}

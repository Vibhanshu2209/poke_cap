import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/widgets/loading_indicator.dart';
import 'package:poke_cap/presentation/widgets/poke_card.dart';

class EvolutionChainFragment extends StatelessWidget {
  final Pokemon current;

  const EvolutionChainFragment({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        "Evolution Chain"
            .tw(ts: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            .padX(24),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
              if (state is RelatedPokemonsLoaded) {
                final evoList = state.evoList
                    .map((i) => Expanded(child: PokeCardItem(pokemon: i)))
                    .toList();
                return Row(
                  children: [
                    ...listOfWidgetsWithSpacing(evoList,
                        seperatorWidget:
                            Icon(Icons.keyboard_double_arrow_right_rounded))
                  ],
                );
              } else {
                return Center(child: PokemonBallIndicator());
              }
            })),
      ],
    );
    // return Placeholder();
  }
}

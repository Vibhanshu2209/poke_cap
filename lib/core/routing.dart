import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/presentation/pages/detailspage.dart';
import 'package:poke_cap/presentation/pages/homepage.dart';

import '../global_exports.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/pokemonDetails/:id',
      builder: (context, state) {
        final Pokemon pokemon = (state.extra as Pokemon);
        BlocProvider.of<PokemonBloc>(context)
            .add(RelatedPokemonItemsForId(pokemon.id));
        return PokemonDetails(pokemon: pokemon);
      },
    ),
  ],
);

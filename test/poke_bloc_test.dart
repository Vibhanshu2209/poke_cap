// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_cap/core/api_service.dart';
import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/models/poke_list.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/domain/repository/pokemon_repo.dart';




class MockPokemonRepository extends Mock implements PokemonRepository {}
class MockAPIService extends Mock implements APIService {}
void main() {
  group('BlocGroupTest', () {

    final mockPokeRepo = MockPokemonRepository();
    final mockEmptyPokemon = [Pokemon.empty(id: 1)];
    var mockPItemList = [PListResultItem(name: "mockPoke", url: "url/1")];

    when(() => mockPokeRepo.getPokemonList()).thenAnswer((_) => Future.value(PokemonListWrapper(count: 1, results: mockPItemList)));

    when(() => mockPokeRepo.getAllDataForPokemonList(mockPItemList)).thenAnswer((_) => Future.value(mockEmptyPokemon));

    blocTest<PokemonBloc, PokemonState>(
      "initial state is correct",
      build: () => PokemonBloc(mockPokeRepo, [], PokemonListWrapper.empty()),
      expect: () => [],
    );

    blocTest<PokemonBloc, PokemonState>(
      "LoadPokemonsEvent is added",
      build: () => PokemonBloc(mockPokeRepo, [], PokemonListWrapper.empty()),
      act: (bloc) => bloc.add(LoadPokemonsEvent()),
      expect: () => [
      isA<PokemonLoading>(),
      isA<PokemonLoaded>().having((s) => s.pokemons, 'pokemons', mockEmptyPokemon),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      "SearchPokemonsEvent",
      build: () {
      final bloc = PokemonBloc(mockPokeRepo, [Pokemon.empty(id: 1)], PokemonListWrapper.empty());
      return bloc;
      },
      act: (bloc) => bloc.add(SearchPokemonsEvent(searchById: 1)),
      expect: () => [
      isA<PokemonLoaded>().having((s) => s.pokemons.length, 'filteredPokemons.length', 1),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      "emits FilterPokemonsEvent",
      build: () {
      final poke = Pokemon.empty(id: 1).copyWith(types: ["fire"]);
      final bloc = PokemonBloc(mockPokeRepo, [poke], PokemonListWrapper.empty());
      return bloc;
      },
      act: (bloc) => bloc.add(FilterPokemonsEvent(types: ["fire"], stats: {})),
      expect: () => [
      isA<PokemonLoaded>().having((s) => s.pokemons.length, 'filteredPokemons.length', 1),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      "emits ReLoadPokemonsEvent",
      build: () {
      final bloc = PokemonBloc(mockPokeRepo, [Pokemon.empty(id: 1)], PokemonListWrapper.empty());
      return bloc;
      },
      act: (bloc) => bloc.add(ReLoadPokemonsEvent()),
      expect: () => [
      isA<PokemonLoaded>().having((s) => s.pokemons.length, 'pokemons.length', 1),
      ], 
    );
  });
}
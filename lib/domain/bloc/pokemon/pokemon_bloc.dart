// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:poke_cap/domain/models/poke_list.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/domain/repository/pokemon_repo.dart';
import 'package:poke_cap/global_exports.dart';

abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final bool isFilterApplied;
  PokemonLoaded({required this.pokemons, this.isFilterApplied = false});
}


class EmptyPokemonList extends PokemonState {}

class RelatedPokemonsLoaded extends PokemonState {
  final Pokemon nextPoke;
  final Pokemon? prevPoke;
  final List<Pokemon> evoList;
  RelatedPokemonsLoaded(
      {required this.prevPoke, required this.nextPoke, required this.evoList});
}

class PokemonError extends PokemonState {
  final String message;
  PokemonError({required this.message});
}

abstract class PokemonEvent {}

class LoadPokemonsEvent extends PokemonEvent {}

class GetPokemonEvolutionChainForId extends PokemonEvent {
  final int id;

  GetPokemonEvolutionChainForId(this.id);
}

class FilterPokemonsEvent extends PokemonEvent {
  final List<String> types;
  final Map<String, List<int>> stats;

  FilterPokemonsEvent({required this.types, required this.stats});
}

class SearchPokemonsEvent extends PokemonEvent {
  final String? searchByName;
  final int? searchById;

  SearchPokemonsEvent({this.searchById, this.searchByName});
}

class ReLoadPokemonsEvent extends PokemonEvent {}

class RelatedPokemonItemsForId extends PokemonEvent {
  final int id;

  RelatedPokemonItemsForId(this.id);
}

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;
  final List<Pokemon> _pokemonList;
  PokemonListWrapper _pokemonListWrapper;

  List<Pokemon> get currentList => _pokemonList;

  PokemonBloc(this.repository, this._pokemonList, this._pokemonListWrapper)
      : super(PokemonInitial()) {
    on<LoadPokemonsEvent>((event, emit) async {
      emit(PokemonLoading());
      try {
        _pokemonListWrapper = await repository.getPokemonList();
        final finalPokeList = await repository
            .getAllDataForPokemonList(_pokemonListWrapper.results);
        _pokemonList.addAll(finalPokeList);
        emit(PokemonLoaded(pokemons: _pokemonList));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    });

    on<RelatedPokemonItemsForId>((event, emit) async {
      int pokeIdAsIndexInList = event.id - 1;
      if (pokeIdAsIndexInList + 1 >= _pokemonList.length) {
        var nextPageUrl = _pokemonListWrapper.nextPageUrl;
        var newWrapper = await repository.getPokemonList(url: nextPageUrl);
        _pokemonListWrapper.nextPageUrl = newWrapper.nextPageUrl;
        _pokemonListWrapper.results.addAll(newWrapper.results);
        final newPokeList =
            await repository.getAllDataForPokemonList(newWrapper.results);
        _pokemonList.addAll(newPokeList);
      }
      Pokemon pItem = _pokemonList[event.id - 1];
      List<Pokemon> evoList = pItem.evolutionChain
          .map<Pokemon>((eId) {
            return _pokemonList.firstWhere(
              (p) => p.id == int.tryParse(eId),
              orElse: () => Pokemon.empty(id: int.tryParse(eId)),
            );
          })
          .where((pokemon) => pokemon.id != -1)
          .cast<Pokemon>() // Explicitly cast to List<Pokemon>
          .toList();
      var prevPoke = pokeIdAsIndexInList == 0
          ? null
          : _pokemonList[pokeIdAsIndexInList - 1];

      var nextPoke = _pokemonList[pokeIdAsIndexInList + 1];
      emit(RelatedPokemonsLoaded(
          evoList: evoList, prevPoke: prevPoke, nextPoke: nextPoke));
    });

    on<ReLoadPokemonsEvent>((event, emit) {
      emit(PokemonLoaded(pokemons: _pokemonList));
    });

    on<FilterPokemonsEvent>((event, emit) {
      final filteredList = _pokemonList.where((pokemon) {
        bool isMatched = matchingFilterOptions(event, pokemon);
        // logger.d(
        //     "Filter: ${event.types} Stats: ${event.stats} Pokemon: ${pokemon.name} isMatched: $isMatched");
        return isMatched;
      }).toList();

      emit(PokemonLoaded(
          pokemons: filteredList, isFilterApplied: true));
    });

    on<SearchPokemonsEvent>((event, emit) {
      try {
        var searchResult = <Pokemon>[];
        if (event.searchById != null) {
          searchResult = [
            _pokemonList.firstWhere(
              (pItem) => pItem.id == event.searchById,
            )
          ];
        } else if (event.searchByName != null) {
          searchResult = _pokemonList
              .where((pItem) => pItem.name.contains(event.searchByName!))
              .toList();
        }
        if (searchResult.isEmpty) {
          emit(EmptyPokemonList());
        }
        emit(PokemonLoaded(
            pokemons: searchResult, isFilterApplied: true));
      } catch (e) {
        emit(PokemonError(message: "No search result found"));
      }
    });
  }

  bool matchingFilterOptions(FilterPokemonsEvent event, Pokemon pokemon) {
    final matchesType = event.types.isEmpty ||
        event.types.any((type) => pokemon.types.contains(type.toLowerCase()));
    final matchesStats = event.stats.entries.every((entry) {
      return matchStatsFilter(entry, pokemon);
    });
    return matchesType && matchesStats;
  }

  bool matchStatsFilter(MapEntry<String, List<int>> entry, Pokemon pokemon) {
    bool pokeStatHasKey = pokemon.stats[entry.key] != null;
    if (!pokeStatHasKey) {
      return false;
    }
    bool isLessThanUpperBound = entry.value.length > 1 &&
        pokemon.stats[entry.key]! <= entry.value.last;
    bool isGreaterThanLowerBound = entry.value.length > 1 &&
        pokemon.stats[entry.key]! >= entry.value.first;
    
    return isLessThanUpperBound && isGreaterThanLowerBound;
  }
}

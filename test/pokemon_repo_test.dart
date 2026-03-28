import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_cap/domain/models/poke_list.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/domain/repository/pokemon_repo.dart';
import 'package:poke_cap/core/api_service.dart';

class MockAPIService extends Mock implements APIService {}

void main() {
  late PokemonRepository repo;
  late MockAPIService mockApi;

  group('PokemonRepository', () {
    mockApi = MockAPIService();
    // Inject the mock APIService into the static field for testing
    PokemonRepository.apiService = mockApi;
    repo = PokemonRepository();


    test('extractEvolutionDetails returns evolution ids', () {
      final evoChain = {
        'chain': {
          'species': {'url': 'https://pokeapi.co/api/v2/pokemon-species/1/'},
          'evolves_to': [
            {
              'species': {'url': 'https://pokeapi.co/api/v2/pokemon-species/2/'},
              'evolves_to': []
            }
          ]
        }
      };
      final result = repo.extractEvolutionDetails(evoChain);
      expect(result, containsAll(['1', '2']));
    });

    test('getDescription returns English description', () {
      final speciesData = {
        'flavor_text_entries': [
          {
            'language': {'name': 'en'},
            'flavor_text': 'A strange seed was planted.'
          },
          {
            'language': {'name': 'jp'},
            'flavor_text': 'Japanese text'
          }
        ]
      };
      final desc = PokemonRepository.getDescription(speciesData);
      expect(desc, contains('A strange seed was planted.'));
    });

    test('getGenderBasedOn returns correct gender map', () {
      final gender = PokemonRepository.getGenderBasedOn(1);
      expect(gender['ClassifyAs'], 'Mostly Male');
      expect(gender['Male'], 87.5);
      expect(gender['Female'], 12.5);
    });
  });
}
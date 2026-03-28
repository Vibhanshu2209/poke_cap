import 'package:poke_cap/core/api_service.dart';
import 'package:poke_cap/domain/models/poke_list.dart';
import 'package:poke_cap/domain/models/pokemon.dart';

import '../../global_exports.dart';

class PokemonRepository {
  static String baseUrl = "https://pokeapi.co/api/v2/pokemon/";
  static String speciesUrl = "https://pokeapi.co/api/v2/pokemon-species/";
  static String typesUrl = "https://pokeapi.co/api/v2/type/";

  static APIService apiService = APIService(baseUrl: baseUrl);

  Future<PokemonListWrapper> getPokemonList(
      {String? url, String? queryParams}) async {
    try {
      var pUrl = url ?? baseUrl;
      var baseApiResult = await apiService.fetchAndReturnAsJsonDecoded(pUrl);
      return PokemonListWrapper.fromMap(baseApiResult);
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<List<Pokemon>> getAllDataForPokemonList(
      List<PListResultItem> pList) async {
    try {
      List<Pokemon> finalPokemonList = [];
      finalPokemonList = await Future.wait(
        pList.map((item) async {
          //Get Details
          final pokemonDetails =
              await apiService.fetchAndReturnAsJsonDecoded(item.url);

          // logger.d(pokemonDetails);

          // //Get Species
          final speciesData = await apiService.fetchAndReturnAsJsonDecoded(
              "$speciesUrl${pokemonDetails["id"]}");
          // logger.d(speciesData);

          // //Get Description
          final description = getDescription(speciesData);

          // // Get egg groups
          final eggGroups = (speciesData['egg_groups'] as List)
              .map<String>((g) => g["name"])
              .toList();
          // logger.d(eggGroups);

          // //Get Gender
          final genderRate = speciesData['gender_rate'];
          final gender = getGenderBasedOn(genderRate);

          final List<String> weaknessess = [];

          for (var type in (pokemonDetails['types'] as List)) {
            var weakness = await getWeaknessForPokemon(type);
            weaknessess.addAll(weakness);
          }

          // // Get Evolution Chain
          final evolutionChain = await apiService.fetchAndReturnAsJsonDecoded(
              speciesData['evolution_chain']['url']);

          List<String> evolutionChainIds =
              extractEvolutionDetails(evolutionChain);

          //Return Pokemon Object
          return Pokemon.customPorting(pokemonDetails,
              description: description,
              evolutionChain: evolutionChainIds,
              eggGroups: eggGroups,
              genderMap: gender,
              weaknessess: weaknessess);
        }),
      );
      return finalPokemonList;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<List<String>> getWeaknessForPokemon(
      Map<dynamic, dynamic> pokemonType) async {
    List<String> weaknessForType = [];

    dynamic typesData;
    if (apiService.typesDataMap.isNotEmpty && apiService.typesDataMap.containsKey(pokemonType["type"]["name"])) {
      // logger.d("Loaded typesData from cache for $pokemonType");
      typesData = apiService.typesDataMap[pokemonType["type"]["name"]];
    } else {
      typesData = await apiService
          .fetchAndReturnAsJsonDecoded(pokemonType["type"]["url"]);
      apiService.typesDataMap[pokemonType["type"]["name"]] = typesData;
    }

    final damageRelations = typesData['damage_relations'];
    weaknessForType = (damageRelations['double_damage_from'] as List)
        .map<String>((item) => item['name'])
        .toList();

    return weaknessForType;
  }

  List<String> extractEvolutionDetails(Map<String, dynamic> json) {
    List<String> speciesList = [];

    void traverseChain(Map<String, dynamic> chain) {
      if (chain.containsKey('species')) {
        var pokemonUrl = (chain['species']['url'] as String);
        String pokeId =
            pokemonUrl.replaceFirst(speciesUrl, "").replaceAll("/", "");
        speciesList.add(pokeId);
      }

      if (chain.containsKey('evolves_to')) {
        for (var nextChain in chain['evolves_to']) {
          traverseChain(nextChain);
        }
      }
    }

    if (json.containsKey('chain')) {
      traverseChain(json['chain']);
    }

    return speciesList;
  }

  static String getDescription(Map<String, dynamic> speciesData) {
    final flavorEntries = speciesData['flavor_text_entries'] as List<dynamic>;
    try {
      final englishEntry = flavorEntries.firstWhere(
        (entry) => entry['language']['name'] == 'en', // return an empty map
      );
      final rawText = englishEntry['flavor_text'] as String;
      return rawText.replaceAll('\n', ' ').replaceAll('\f', ' ').trim();
    } catch (e) {
      return '';
    }
  }

  static Map<String, dynamic> getGenderBasedOn(int genderRate) {
    if (genderRate == -1) {
      return {
        "ClassifyAs": "GenderLess",
        "Female": 0,
        "Male": 0,
      };
    }

    double malePercent;
    double femalePercent;
    String classify;

    switch (genderRate) {
      case 0:
        malePercent = 100;
        femalePercent = 0;
        classify = "Male";
        break;
      case 1:
        malePercent = 87.5;
        femalePercent = 12.5;
        classify = "Mostly Male";
        break;
      case 2:
        malePercent = 75;
        femalePercent = 25;
        classify = "More Male";
        break;
      case 3:
        malePercent = 50;
        femalePercent = 50;
        classify = "Equal";
        break;
      case 4:
        malePercent = 25;
        femalePercent = 75;
        classify = "More Female";
        break;
      case 5:
        malePercent = 0;
        femalePercent = 100;
        classify = "Female";
        break;
      case 6:
        malePercent = 12.5;
        femalePercent = 87.5;
        classify = "Mostly Female";
        break;
      case 7:
        malePercent = 0;
        femalePercent = 100;
        classify = "Female"; // Often same as 5 and 8
        break;
      case 8:
        malePercent = 0;
        femalePercent = 100;
        classify = "Female";
        break;
      default:
        malePercent = 0;
        femalePercent = 0;
        classify = "Unknown"; // Handle unexpected gender rates
        break;
    }

    return {
      "ClassifyAs": classify,
      "Female": femalePercent,
      "Male": malePercent,
    };
  }
}

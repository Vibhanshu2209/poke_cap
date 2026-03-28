import 'package:equatable/equatable.dart';

/// Data class representing the relevant parts of the Pokemon Species API schema.
///
/// This class focuses on the `evolution_chain` and `flavor_text_entries` fields.
class PokemonSpecies extends Equatable {
  final EvolutionChain? evolutionChain;
  final List<FlavorTextEntry> flavorTextEntries;

  const PokemonSpecies({
    required this.evolutionChain,
    required this.flavorTextEntries,
  });

  // Factory constructor to create a PokemonSpecies object from a JSON map.
  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(
      evolutionChain: json['evolution_chain'] == null
          ? null
          : EvolutionChain.fromJson(json['evolution_chain']),
      flavorTextEntries: (json['flavor_text_entries'] as List)
          .map((entry) => FlavorTextEntry.fromJson(entry))
          .toList(),
    );
  }

  // Factory constructor to create a PokemonSpecies object from a Map.
  factory PokemonSpecies.fromMap(Map<String, dynamic> map) {
    return PokemonSpecies(
      evolutionChain: map['evolutionChain'] == null
          ? null
          : EvolutionChain.fromMap(map['evolutionChain']),
      flavorTextEntries: (map['flavorTextEntries'] as List)
          .map((entry) => FlavorTextEntry.fromMap(entry))
          .toList(),
    );
  }

  // Converts the PokemonSpecies object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'evolution_chain': evolutionChain?.toJson(),
      'flavor_text_entries':
          flavorTextEntries.map((entry) => entry.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [evolutionChain, flavorTextEntries];
}

/// Data class representing the evolution chain URL.
///
///  The API returns the evolution chain as a URL, so we only need to store the URL.
class EvolutionChain extends Equatable {
  final String url;

  const EvolutionChain({required this.url});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(
      url: json['url'],
    );
  }
  factory EvolutionChain.fromMap(Map<String, dynamic> map) {
    return EvolutionChain(
      url: map['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  @override
  List<Object?> get props => [url];
}

/// Data class representing a flavor text entry.
///
/// This class holds the flavor text, the language it's in, and the game version it's from.
class FlavorTextEntry extends Equatable {
  final String flavorText;
  final Language language;
  final Version version;

  const FlavorTextEntry({
    required this.flavorText,
    required this.language,
    required this.version,
  });

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntry(
      flavorText: json['flavor_text'],
      language: Language.fromJson(json['language']),
      version: Version.fromJson(json['version']),
    );
  }

  factory FlavorTextEntry.fromMap(Map<String, dynamic> map) {
    return FlavorTextEntry(
      flavorText: map['flavorText'],
      language: Language.fromMap(map['language']),
      version: Version.fromMap(map['version']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flavor_text': flavorText,
      'language': language.toJson(),
      'version': version.toJson(),
    };
  }

  @override
  List<Object?> get props => [flavorText, language, version];
}

/// Data class representing a language.
///
///  Stores the name and url of the language.
class Language extends Equatable {
  final String name;
  final String url;

  const Language({required this.name, required this.url});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
      url: json['url'],
    );
  }
  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name'],
      url: map['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [name, url];
}

/// Data class representing a version.
///
/// Stores the name and url of the version.
class Version extends Equatable {
  final String name;
  final String url;

  const Version({required this.name, required this.url});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      name: json['name'],
      url: json['url'],
    );
  }
  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      name: map['name'],
      url: map['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [name, url];
}

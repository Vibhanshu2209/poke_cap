import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:poke_cap/global_exports.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<String> types;
  final List<String> abilities;
  final double height;
  final double weight;
  final Map<String, dynamic> gender;
  final List<String> eggGroups;
  final Map<String, int> stats;
  final List<String> evolutionChain;
  final List<String> weaknessess;

  const Pokemon(
      {required this.id,
      required this.name,
      required this.description,
      required this.types,
      required this.abilities,
      required this.height,
      required this.weight,
      required this.gender,
      required this.eggGroups,
      required this.stats,
      required this.evolutionChain,
      required this.weaknessess});

  factory Pokemon.customPorting(
    Map<String, dynamic> map, {
    required String description,
    required List<String> evolutionChain,
    required List<String> weaknessess,
    required List<String> eggGroups,
    required Map<String, dynamic> genderMap,
  }) {
    return Pokemon(
        id: map['id'] as int,
        name: map['name'] as String,
        description: description,
        abilities: List<String>.from((map['abilities'] as List)
            .map((ability) => ability['ability']['name'])),
        height: (map['height'] as num).toDouble(),
        weight: (map['weight'] as num).toDouble(),
        types: List<String>.from(
            (map['types'] as List).map((type) => type['type']['name'])),
        gender: genderMap,
        eggGroups: eggGroups,
        stats: Map<String, int>.from((map['stats'] as List).asMap().map(
            (_, stat) => MapEntry(stat['stat']['name'], stat['base_stat']))),
        evolutionChain: evolutionChain,
        weaknessess: weaknessess);
  }

  factory Pokemon.empty({int? id}) {
    return Pokemon(
        id: id ?? -1,
        name: "",
        description: "",
        types: [],
        abilities: [],
        height: -1,
        weight: -1,
        gender: {},
        eggGroups: [],
        stats: {},
        evolutionChain: [],
        weaknessess: []);
  }

  Pokemon copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? types,
    List<String>? abilities,
    double? height,
    double? weight,
    Map<String, dynamic>? gender,
    List<String>? eggGroups,
    Map<String, int>? stats,
    List<String>? evolutionChain,
    List<String>? weaknessess,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      types: types ?? this.types,
      abilities: abilities ?? this.abilities,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      eggGroups: eggGroups ?? this.eggGroups,
      stats: stats ?? this.stats,
      evolutionChain: evolutionChain ?? this.evolutionChain,
      weaknessess: weaknessess ?? this.weaknessess,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'types': types,
      'abilities': abilities,
      'height': height,
      'weight': weight,
      'gender': gender,
      'eggGroups': eggGroups,
      'stats': stats,
      'evolutionChain': evolutionChain,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        types,
        abilities,
        height,
        weight,
        gender,
        eggGroups,
        stats,
        evolutionChain
      ];

  @override
  bool get stringify => true;

  String get abilitiesPresentation =>
      abilities.map((x) => x.capitalizeFirstLetter()).toList().join(", ");
  String get eggGroupsPresentation =>
      eggGroups.map((x) => x.capitalizeFirstLetter()).toList().join(", ");
}

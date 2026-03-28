import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:poke_cap/domain/models/pokemon.dart';

class PokemonListWrapper extends Equatable {
  final int count;
  String? prevPageUrl;
  String? nextPageUrl;
  final List<PListResultItem> results;

  PokemonListWrapper({
    required this.count,
    this.prevPageUrl,
    this.nextPageUrl,
    required this.results,
  });

  PokemonListWrapper copyWith({
    int? count,
    String? prevPageUrl,
    String? nextPageUrl,
    List<PListResultItem>? results,
  }) {
    return PokemonListWrapper(
      count: count ?? this.count,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'prevPageUrl': prevPageUrl,
      'nextPageUrl': nextPageUrl,
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory PokemonListWrapper.fromMap(Map<String, dynamic> map) {
    return PokemonListWrapper(
      count: map['count'] as int,
      prevPageUrl: map['previous'] != null ? map['previous'] as String : null,
      nextPageUrl: map['next'] != null ? map['next'] as String : null,
      results: List<PListResultItem>.from(
        (map['results'] as dynamic).map<PListResultItem>(
          (x) => PListResultItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonListWrapper.fromJson(String source) =>
      PokemonListWrapper.fromMap(json.decode(source) as Map<String, dynamic>);

  factory PokemonListWrapper.empty() {
    return PokemonListWrapper(count: 0, results: []);
  }

  @override
  List<Object?> get props => [count, prevPageUrl, nextPageUrl, results];
}

class PListResultItem extends Equatable {
  final String name;
  final String url;
  final Pokemon? pokemon;

  const PListResultItem({required this.name, required this.url, this.pokemon});

  PListResultItem copyWith({String? name, String? url, Pokemon? pokemon}) {
    return PListResultItem(
        name: name ?? this.name,
        url: url ?? this.url,
        pokemon: pokemon ?? this.pokemon);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory PListResultItem.fromMap(Map<String, dynamic> map) {
    return PListResultItem(
        name: map['name'] as String, url: map['url'] as String);
  }

  String toJson() => json.encode(toMap());

  factory PListResultItem.fromJson(String source) =>
      PListResultItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [name, url];
}

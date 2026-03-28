import 'dart:ui';

import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/pages/filter_dialog.dart';
import 'package:poke_cap/presentation/widgets/custom_button.dart';
import 'package:poke_cap/presentation/widgets/loading_indicator.dart';
import 'package:poke_cap/presentation/widgets/poke_card.dart';
import 'package:poke_cap/presentation/widgets/theme_toggle_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _editingController;
  bool isFilterApplied = false;

  void setFilterApplied(bool value) {
    setState(() {
      isFilterApplied = value;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  String? _validateText(String? value) {
    if (value == null || value.parseAsIntOrElse(defaultVal: -1) == -1) {
      return "Try a Number greater than 0";
    }
    return null; // Return null if the validation passes
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.displayMedium?.color ?? Colors.black;
    final subtextColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.black54;
    final dividerColor = Theme.of(context).dividerColor;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black54;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pokédex',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ).padY(8),
                const ThemeToggleButton(),
              ],
            ),
            Divider(color: dividerColor, thickness: 2),
            Text(
              'Search for any Pokémon that exists on the planet',
              style: TextStyle(fontSize: 16, color: subtextColor),
            ).padY(8),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: _validateText,
                        onChanged: (value) {
                          var valueAsInt = value.parseAsIntOrElse(defaultVal: -1);
                          if (value.isEmpty || valueAsInt == 0) {
                            logger.d(
                                "loading original results as no searchable text is provided");
                            BlocProvider.of<PokemonBloc>(context)
                                .add(ReLoadPokemonsEvent());
                            return;
                          }
                          if (valueAsInt == -1) {
                            logger.d("User is searching by name");
                            BlocProvider.of<PokemonBloc>(context)
                                .add(SearchPokemonsEvent(searchByName: value));
                          } else {
                            BlocProvider.of<PokemonBloc>(context)
                                .add(SearchPokemonsEvent(searchById: valueAsInt));
                          }
                        },
                        controller: _editingController,
                        selectionHeightStyle: BoxHeightStyle.max,
                        decoration: InputDecoration(
                          focusColor: PokemonColors.buttonColor,
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          fillColor: Theme.of(context).colorScheme.surface,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Theme.of(context).colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: PokemonColors.buttonColor)),
                          filled: true,
                          hintText: 'Name or Number',
                          suffixIcon: Icon(
                            Icons.search,
                            color: iconColor,
                            size: 32,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialog();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: PokemonColors.searchField,
                        backgroundColor: PokemonColors.buttonColor,
                        elevation: 0,
                        // Adjust padding as needed
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Adjust roundness
                        ),
                      ),
                      child: Icon(
                        Icons.tune_rounded,size: 28,
                      ),
                    ),
                  ),
                  if (isFilterApplied)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: PokemonColors.buttonColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                        onPressed: () {
                          BlocProvider.of<PokemonBloc>(context)
                              .add(ReLoadPokemonsEvent());
                        },
                        child: "Clear".tw(ts: Theme.of(context).textTheme.bodyMedium))
                ],
              ),
            ),
            const SizedBox(height: 16),
            _gridViewBuilder(setFilterApplied)
          ],
        ),
      ),
    );
  }

  // lib/presentation/pages/homepage.dart

  Widget _gridViewBuilder(void Function(bool value) setFilterApplied) {
    return BlocConsumer<PokemonBloc, PokemonState>(
      listener: (context, state) => {
        if (state is PokemonLoaded) {
          setFilterApplied(state.isFilterApplied)
        }
      },
      builder: (context, state) {
      if (state is PokemonLoading) {
        return Center(child: PokemonBallIndicator());
      } else if (state is PokemonError) {
        return Center(
            child: state.message.tw(fontColor: Colors.redAccent, fontSize: 22));
      } else if (state is PokemonLoaded) {
        final pokemons = state.pokemons;

        if (pokemons.isEmpty) {
          logger.d("Empty List ");
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  "No Pokemons Found. Try clearing/changing filters".tw(),
                  SizedBox(
                    height: 60,
                    child: ActionButton(
                      item: "Clear Filters",
                      isPrimary: false,
                      navigateCallback: () {
                        BlocProvider.of<PokemonBloc>(context)
                            .add(ReLoadPokemonsEvent());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(child: _gridView(pokemons));
      } else {
        return Expanded(child: Placeholder());
      }
    });
  }

  Widget _gridView(List<Pokemon> pokemons) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return PokeCardItem(
            pokemon: pokemons[index],
            newStyleWidget: false,
            showNameAndId: true);
      },
    ).limitedwidth();
  }
}

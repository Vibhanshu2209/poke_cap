// import 'package:poke_cap/domain/models/poke_species.dart';
import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/models/pokemon.dart';
import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/widgets/boxed_image_view.dart';
import 'package:poke_cap/presentation/widgets/colored_chip.dart';
import 'package:poke_cap/presentation/widgets/custom_button.dart';
import 'package:poke_cap/presentation/widgets/evolution_chain.dart';
import 'package:poke_cap/presentation/widgets/loading_indicator.dart';
import 'package:poke_cap/presentation/widgets/stats_display.dart';

class PokemonDetails extends StatelessWidget {
  const PokemonDetails({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildImageAndDescription(context),
            _buildOverviewSection(context),
            _buildStats(context),
            EvolutionChainFragment(current: pokemon),
            _nextPrevButton(context),
            SizedBox(height: 100)
          ],
        ),
      ).limitedwidth(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pokemon.name.toUpperCase().tw(
                  ts: Theme.of(context)
                      .textTheme
                      .displayMedium!),
              "00${pokemon.id}"
                  .toString()
                  .tw(ts: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<PokemonBloc>(context).add(ReLoadPokemonsEvent());
            context.pushReplacement("/");
          },
          icon: Icon(Icons.cancel_outlined),
          iconSize: 40,
        ),
      ],
    ).padAll(24);
  }

  Widget _buildImageAndDescription(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(child: BoxedImageView(pokemon: pokemon)),
          Expanded(child: pokemon.description.tw(align: TextAlign.justify, ts: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 22))),
        ],
      ),
    ).padX(18);
  }

  Widget _buildOverviewSection(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _overviewSingleItem(context, "Height",
                plainTextValue: pokemon.height.toString()),
            _overviewSingleItem(context, "Weight",
                plainTextValue: pokemon.weight.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _overviewSingleItem(context, "Gender(s)",
                customComponent: _genderChip(pokemon.gender, context)),
            _overviewSingleItem(context, "Egg Groups",
                plainTextValue: pokemon.eggGroupsPresentation)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _overviewSingleItem(context, "Abilities",
                plainTextValue: pokemon.abilitiesPresentation),
            _overviewSingleItem(context, "Types",
                colorCodeValues: pokemon.types)
          ],
        ),
        Row(
          children: [
            _overviewSingleItem(context, "Weak Against",
                colorCodeValues: pokemon.weaknessess),
          ],
        )
      ],
    ).padX(30);
  }

  Widget _genderChip(Map<String, dynamic> genderMap, BuildContext context) {
    double fValue = genderMap["Female"] / 100;
    double mValue = genderMap["Male"] / 100;

    List<double> stops = [];
    List<Color> colors = [];
    if (fValue > 0.0) {
      stops.add(fValue);
      colors.add(Colors.pinkAccent);
    }
    if (mValue > 0.0) {
      stops.add(mValue);
      colors.add(Colors.blueAccent);
    }

    String classifyAs = (genderMap["ClassifyAs"] as String);
    if (classifyAs == "GenderLess") {
      stops = [];
      colors = [Colors.grey];
    }

    final borderColor = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white30 
        : Colors.black;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: colors, stops: stops),
          border: Border.all(color: borderColor, width: 1.2)),
      child: (genderMap["ClassifyAs"] as String)
          .capitalizeFirstLetter()
          .tw()
          .padX(4)
          .padY(4),
    );
  }

  Widget _overviewSingleItem(BuildContext context, String heading,
      {String? plainTextValue,
      List<String>? colorCodeValues,
      Widget? customComponent}) {
    if (customComponent != null) {
      plainTextValue = null;
      colorCodeValues = null;
    }
    return Expanded(
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading.tw(
              ts: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          if (customComponent != null) customComponent,
          if (plainTextValue != null)
            plainTextValue.tw(ts: Theme.of(context).textTheme.titleMedium),
          if (colorCodeValues != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  ...colorCodeValues.map((val) => ColoredChip(value: val))
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statsBackground = isDarkMode 
        ? PokemonColors.statsFragmentBgDark 
        : PokemonColors.statsFragmentBg;
    
    return Container(
      color: statsBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...pokemon.stats.entries.map((entry) {
            return CustomStatsItem(entry: entry);
          }),
        ],
      ).padAll(24),
    );
  }

  Widget _nextPrevButton(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200),
        child:
            BlocBuilder<PokemonBloc, PokemonState>(builder: (context, state) {
          if (state is RelatedPokemonsLoaded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (state.prevPoke != null)
                  ActionButton(
                    item: state.prevPoke!.name,
                    arrow: PointTowards.left,
                    navigateCallback: () {
                      context.pushReplacement(
                          "/pokemonDetails/${state.prevPoke!.id}",
                          extra: state.prevPoke!);
                    },
                  ),
                ActionButton(
                  item: state.nextPoke.name,
                  arrow: PointTowards.right,
                  navigateCallback: () {
                    context.pushReplacement(
                        "/pokemonDetails/${state.nextPoke.id}",
                        extra: state.nextPoke);
                  },
                ),
              ],
            );
          } else {
            return PokemonBallIndicator();
          }
        }));
  }
}

class CustomStatsItem extends StatelessWidget {
  final MapEntry<String, int> entry;

  const CustomStatsItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return StatDisplay(
        statName: StringConst.getContentString(entry.key),
        statValue: entry.value,
        barColor: PokemonColors.buttonColor);
  }
}

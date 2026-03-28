// lib/presentation/pages/filter_dialog.dart

import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/global_exports.dart';
import 'package:poke_cap/presentation/widgets/custom_button.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> selectedTypes = [];
  Map<String, RangeValues> selectedStats = {
    'hp': RangeValues(0, 210),
    'attack': RangeValues(0, 210),
    'defense': RangeValues(0, 210),
    'speed': RangeValues(0, 210),
    'special-attack': RangeValues(0, 210),
    'special-defense': RangeValues(0, 210),
  };

  final categoryBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
      side: BorderSide(color: PokemonColors.buttonColor, width: 1.2));

  final List<String> _allTypes = [
    'Normal',
    'Fighting',
    'Flying',
    'Poison',
    'Ground',
    'Rock',
    'Bug',
    'Ghost',
    'Steel',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Dark',
    'Fairy',
    'Unknown',
    'Shadow',
  ];

  void _toggleType(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: PokemonColors.background,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filters'),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close_fullscreen))
        ],
      ),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSection(),
              _buildStatsSection(),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
                isPrimary: false,
                item: "Reset",
                navigateCallback: () {
                  BlocProvider.of<PokemonBloc>(context)
                      .add(ReLoadPokemonsEvent());
                  Navigator.of(context).pop();
                }),
            ActionButton(
                item: "Apply",
                navigateCallback: () {
                  BlocProvider.of<PokemonBloc>(context).add(
                    FilterPokemonsEvent(
                        types: selectedTypes,
                        stats: selectedStats.map((key, value) => MapEntry(
                            key, [value.start.toInt(), value.end.toInt()]))),
                  );
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSection() {
    final selectedItemsStringBuilder = selectedTypes.isEmpty
        ? "No Types Selected"
        : "${selectedTypes.first}${selectedTypes.length > 1 ? " + ${selectedTypes.length - 1} More" : ""}";

    return ExpansionTile(
      collapsedShape: categoryBorder,
      shape: categoryBorder,
      showTrailingIcon: true,
      trailing: Text(
        selectedItemsStringBuilder,
        style: TextStyle(color: Colors.grey.shade600),
      ),
      title: Text('Type'),
      children: [
        Divider(height: 1, color: Colors.grey.shade300),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _allTypes.map((type) {
              return _buildTypeChip(type);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    return FilterChip(
      label: Text(type),
      backgroundColor: PokemonColors.background,
      selectedColor: PokemonColors.getColorByType(type.toLowerCase()),
      selected: selectedTypes.contains(type),
      onSelected: (bool selected) {
        _toggleType(type);
      },
    );
  }

  Widget _buildStatsSection() {
    return ExpansionTile(
      collapsedShape: categoryBorder,
      shape: categoryBorder,
      showTrailingIcon: true,
      title: Text('Stats'),
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      children: selectedStats.keys.map((stat) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConst.getContentString(stat),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black87),
            ),
            RangeSlider(
              values: selectedStats[stat]!,
              min: 0,
              max: 210,
              divisions: 21,
              labels: RangeLabels(
                selectedStats[stat]!.start.round().toString(),
                selectedStats[stat]!.end.round().toString(),
              ),
              onChanged: (values) {
                setState(() {
                  selectedStats[stat] = values;
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}

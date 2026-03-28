import 'package:poke_cap/global_exports.dart';

enum PointTowards { left, right, none }

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.item,
      this.arrow = PointTowards.none,
      required this.navigateCallback,
      this.isPrimary = true});

  final String item;
  final PointTowards arrow;
  final Function() navigateCallback;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        isPrimary ? PokemonColors.buttonColor : PokemonColors.background;
    Color iconTextColor =
        !isPrimary ? PokemonColors.buttonColor : PokemonColors.background;
    return Expanded(
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: navigateCallback,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.5, maxHeight: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: bgColor,
              border: Border.all(color: iconTextColor)),
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (arrow == PointTowards.left)
                Icon(Icons.navigate_before_rounded, color: iconTextColor),
              item.capitalizeFirstLetter().tw(
                    ts: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
                          color: iconTextColor,
                        ),
                  ),
              if (arrow == PointTowards.right)
                Icon(Icons.navigate_next_rounded, color: iconTextColor)
            ],
          ).padX(24).padY(12),
        ),
      ),
    );
  }
}

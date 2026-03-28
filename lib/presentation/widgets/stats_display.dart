import 'package:poke_cap/global_exports.dart';

// Reusable widget for displaying a single stat
class StatDisplay extends StatelessWidget {
  final String statName;
  final int statValue;
  final Color barColor;
  final int maxValue; // Added maxValue for consistent bar scaling

  const StatDisplay({
    super.key,
    required this.statName,
    required this.statValue,
    required this.barColor,
    this.maxValue = 100, // Default max value, adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the fill ratio, capping it at 1.0
    double fillRatio = (statValue / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              statName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              // Use LayoutBuilder
              builder: (context, constraints) {
                final barHeight = 14.0; // Define the height of the bar

                return Stack(
                  children: [
                    Container(
                      height: barHeight, // Use the calculated height
                      decoration: BoxDecoration(
                        color: PokemonColors.statBarBg, // Background of the bar
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: fillRatio,
                      child: Container(
                        height: barHeight, // Use the calculated height
                        decoration: BoxDecoration(
                          color: barColor, // Color of the filled part
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            statValue.toString(),
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white),
                          ).padX(4).padY(2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

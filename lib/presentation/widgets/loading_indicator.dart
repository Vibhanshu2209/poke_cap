import 'package:poke_cap/global_exports.dart';

class PokemonBallIndicator extends StatefulWidget {
  const PokemonBallIndicator({super.key});

  @override
  _PokemonBallIndicatorState createState() => _PokemonBallIndicatorState();
}

class _PokemonBallIndicatorState extends State<PokemonBallIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Increased duration for smoother animation
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation

    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(
      // Added curve for more dynamic scaling
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween(begin: 0.0, end: 2 * 3.14159265359).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear), // Full rotation, linear
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: 50, // Increased size for better visibility
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2), // Added border
            gradient: const LinearGradient( // Added gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red,
                Colors.red,
                Colors.white,
                Colors.white,
                Colors.blue,
                Colors.blue,
              ],
              stops: [0.0, 0.45, 0.45, 0.55, 0.55, 1.0], // Corrected stops
            ),
          ),
          child: Stack(
            children: [
              // Black line across the middle
              Positioned(
                top: 24, // Centered the line
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: Colors.black,
                ),
              ),
              // Center button
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:poke_cap/domain/bloc/theme/theme_bloc.dart';
import 'package:poke_cap/domain/bloc/theme/theme_event.dart';
import 'package:poke_cap/domain/bloc/theme/theme_state.dart';
import 'package:poke_cap/global_exports.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final iconColor = Theme.of(context).iconTheme.color ?? Colors.black54;
        return IconButton(
          icon: Icon(
            themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: iconColor,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          },
          tooltip: themeState.isDarkMode ? 'Light Mode' : 'Dark Mode',
        );
      },
    );
  }
}

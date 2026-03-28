import 'package:poke_cap/domain/bloc/pokemon/pokemon_bloc.dart';
import 'package:poke_cap/domain/bloc/theme/theme_bloc.dart';
import 'package:poke_cap/domain/bloc/theme/theme_event.dart';
import 'package:poke_cap/domain/bloc/theme/theme_state.dart';
import 'package:poke_cap/domain/models/poke_list.dart';
import 'package:poke_cap/domain/repository/pokemon_repo.dart';

import 'global_exports.dart';
import 'package:poke_cap/core/routing.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PokemonBloc(
              PokemonRepository(), [], PokemonListWrapper.empty())
            ..add(LoadPokemonsEvent()),
        ),
        BlocProvider(
          create: (_) {
            final themeBloc = ThemeBloc();
            // Initialize with system theme detection
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final brightness = MediaQuery.of(context).platformBrightness;
              final systemIsDarkMode = brightness == Brightness.dark;
              themeBloc.add(InitializeThemeEvent(systemIsDarkMode: systemIsDarkMode));
            });
            return themeBloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            theme: themeState.themeData,
            darkTheme: themeState.themeData,
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}

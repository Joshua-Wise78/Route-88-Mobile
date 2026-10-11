import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/home/view/home_page.dart';
import 'package:route_88/features/route88/bloc/construction/construction_bloc.dart';
import 'package:route_88/features/route88/bloc/incidents/incidents_bloc.dart';
import 'package:route_88/features/route88/bloc/slowdowns/slowdowns_bloc.dart';
import 'package:route_88/features/route88/domain/usecases/get_incidents_usecase.dart';
import 'package:route_88/features/route88/repositories/construction_repository.dart';
import 'package:route_88/features/route88/repositories/incident_repository.dart';
import 'package:route_88/features/route88/repositories/slowdown_repository.dart';
import 'package:route_88/features/routing/bloc/routing_bloc.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';
import 'package:route_88/l10n/l10n.dart';

class App extends StatelessWidget {
  App({super.key}) : _apiClient = ApiClient();

  final ApiClient _apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => IncidentRepository(apiClient: _apiClient),
        ),
        RepositoryProvider(
          create: (context) => SlowdownRepository(apiClient: _apiClient),
        ),
        RepositoryProvider(
          create: (context) => ConstructionRepository(apiClient: _apiClient),
        ),
        RepositoryProvider(
          create: (context) => RoutingRepository(apiClient: _apiClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => IncidentsBloc(
              getIncidentsUseCase: GetIncidentsUseCase(
                context.read<IncidentRepository>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => SlowdownsBloc(
              repository: context.read<SlowdownRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ConstructionBloc(
              repository: context.read<ConstructionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RoutingBloc(
              routingRepository: context.read<RoutingRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
  }
}

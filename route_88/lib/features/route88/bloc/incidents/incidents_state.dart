import 'package:route_88/features/route88/models/incident.dart';

sealed class IncidentsState {
  const IncidentsState();
}

class IncidentInitial extends IncidentsState {
  const IncidentInitial();
}

class IncidentsLoading extends IncidentsState {
  const IncidentsLoading();
}

class IncidentsLoaded extends IncidentsState {
  const IncidentsLoaded(this.incidents);
  final List<Incident> incidents;
}

class IncidentsError extends IncidentsState {
  const IncidentsError(this.message);
  final String message;
}

import 'package:route_88/features/route88/models/incident.dart';
import 'package:route_88/features/route88/repositories/incident_repository.dart';

class GetIncidentsUseCase {
  const GetIncidentsUseCase(this._repository);
  final IncidentRepository _repository;

  Future<List<Incident>> call({
    required double latitude,
    required double longitude,
    required double radiusMiles,
  }) async {
    return _repository.getIncidents(
      latitude: latitude,
      longitude: longitude,
      radiusMiles: radiusMiles,
    );
  }
}

import 'package:route_88/features/route88/models/slowdowns.dart';
import 'package:route_88/features/route88/repositories/slowdown_repository.dart';

class GetSlowdownsUseCase {
  const GetSlowdownsUseCase(this._repository);
  final SlowdownRepository _repository;

  Future<List<Slowdown>> call({
    required double latitude,
    required double longitude,
    required double radiusMiles,
  }) async {
    return _repository.getSlowdowns(
      latitude: latitude,
      longitude: longitude,
      radiusMiles: radiusMiles,
    );
  }
}

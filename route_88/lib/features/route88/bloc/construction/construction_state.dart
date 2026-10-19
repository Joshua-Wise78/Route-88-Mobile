import 'package:route_88/features/route88/models/construction.dart';

sealed class ConstructionState {
  const ConstructionState();
}

class ConstructionInitial extends ConstructionState {
  const ConstructionInitial();
}

class ConstructionLoading extends ConstructionState {
  const ConstructionLoading();
}

class ConstructionLoaded extends ConstructionState {
  const ConstructionLoaded(this.construction);
  final List<Construction> construction;
}

class ConstructionError extends ConstructionState {
  const ConstructionError(this.message);
  final String message;
}

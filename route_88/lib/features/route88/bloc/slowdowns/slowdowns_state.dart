import 'package:route_88/features/route88/models/slowdowns.dart';

sealed class SlowdownsState {
  const SlowdownsState();
}

class SlowdownsInitial extends SlowdownsState {
  const SlowdownsInitial();
}

class SlowdownsLoading extends SlowdownsState {
  const SlowdownsLoading();
}

class SlowdownsLoaded extends SlowdownsState {
  const SlowdownsLoaded(this.slowdowns);
  final List<Slowdown> slowdowns;
}

class SlowdownsError extends SlowdownsState {
  const SlowdownsError(this.message);
  final String message;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/routine_service.dart';
import '../models/routine_model.dart';

final routineServiceProvider = Provider((ref) => RoutineService());

final routinesStreamProvider = StreamProvider.autoDispose<List<Routine>>((ref) {
  return ref.watch(routineServiceProvider).getRoutinesStream();
});

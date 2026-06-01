import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';
import 'package:equatable/equatable.dart';

class MarkNotificationReadUseCase implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) async {
    return await repository.markNotificationRead(params.id);
  }
}

class MarkNotificationReadParams extends Equatable {
  final String id;

  const MarkNotificationReadParams(this.id);

  @override
  List<Object> get props => [id];
}

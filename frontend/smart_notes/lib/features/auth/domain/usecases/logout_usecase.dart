import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase implements UseCaseNoParams<void> {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}

// Placeholder usecase
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetDashboardStatsUsecase implements UseCaseNoParams<void> {
  @override
  Future<Either<Failure, void>> call() async {
    return const Right(null);
  }
}

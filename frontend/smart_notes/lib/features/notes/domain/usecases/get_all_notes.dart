import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllNotes implements UseCase<List<Note>, NoParams> {
  final NotesRepository repository;

  GetAllNotes(this.repository);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    print('🎯 GetAllNotes: UseCase called');
    try {
      final result = await repository.getAllNotes();
      print('🎯 GetAllNotes: Repository returned result');
      return result;
    } catch (e) {
      print('❌ GetAllNotes: Exception caught: $e');
      return Left(UnknownFailure('Failed to get notes: $e'));
    }
  }
}

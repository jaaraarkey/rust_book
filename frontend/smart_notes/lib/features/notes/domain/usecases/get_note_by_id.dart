import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetNoteById implements UseCase<Note, GetNoteByIdParams> {
  final NotesRepository repository;

  GetNoteById(this.repository);

  @override
  Future<Either<Failure, Note>> call(GetNoteByIdParams params) async {
    return await repository.getNoteById(params.id);
  }
}

class GetNoteByIdParams extends Equatable {
  final String id;

  const GetNoteByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}

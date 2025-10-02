import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateNote implements UseCase<Note, UpdateNoteParams> {
  final NotesRepository repository;

  UpdateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(UpdateNoteParams params) async {
    final updatedNote = params.note.copyWith(
      updatedAt: DateTime.now(),
    );
    return await repository.updateNote(updatedNote);
  }
}

class UpdateNoteParams extends Equatable {
  final Note note;

  const UpdateNoteParams({required this.note});

  @override
  List<Object> get props => [note];
}

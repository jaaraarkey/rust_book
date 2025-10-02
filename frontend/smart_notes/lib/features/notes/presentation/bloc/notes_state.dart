import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteLoaded extends NotesState {
  final Note note;

  const NoteLoaded(this.note);

  @override
  List<Object> get props => [note];
}

class NoteCreated extends NotesState {
  final Note note;

  const NoteCreated(this.note);

  @override
  List<Object> get props => [note];
}

class NoteUpdated extends NotesState {
  final Note note;

  const NoteUpdated(this.note);

  @override
  List<Object> get props => [note];
}

class NoteDeleted extends NotesState {
  final String noteId;

  const NoteDeleted(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class NotesSearchResults extends NotesState {
  final List<Note> notes;
  final String query;

  const NotesSearchResults(this.notes, this.query);

  @override
  List<Object> get props => [notes, query];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllNotes extends NotesEvent {}

class LoadNotesByFolder extends NotesEvent {
  final String folderId;

  const LoadNotesByFolder(this.folderId);

  @override
  List<Object> get props => [folderId];
}

class LoadNoteById extends NotesEvent {
  final String id;

  const LoadNoteById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateNoteEvent extends NotesEvent {
  final String title;
  final String content;
  final String? folderId;
  final List<String> tags;
  final String? color;

  const CreateNoteEvent({
    required this.title,
    required this.content,
    this.folderId,
    this.tags = const [],
    this.color,
  });

  @override
  List<Object?> get props => [title, content, folderId, tags, color];
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NotesEvent {
  final String id;

  const DeleteNoteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchNotesEvent extends NotesEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleNotePinEvent extends NotesEvent {
  final Note note;

  const ToggleNotePinEvent(this.note);

  @override
  List<Object> get props => [note];
}

class ToggleNoteArchiveEvent extends NotesEvent {
  final Note note;

  const ToggleNoteArchiveEvent(this.note);

  @override
  List<Object> get props => [note];
}

class LoadPinnedNotes extends NotesEvent {}

class LoadArchivedNotes extends NotesEvent {}

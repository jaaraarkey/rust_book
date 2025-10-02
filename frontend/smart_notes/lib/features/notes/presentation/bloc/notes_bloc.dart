import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/get_all_notes.dart';
import '../../domain/usecases/get_note_by_id.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../../../core/usecases/usecase.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotes getAllNotes;
  final GetNoteById getNoteById;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NotesBloc({
    required this.getAllNotes,
    required this.getNoteById,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NotesInitial()) {
    on<LoadAllNotes>(_onLoadAllNotes);
    on<LoadNoteById>(_onLoadNoteById);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<ToggleNotePinEvent>(_onToggleNotePin);
    on<ToggleNoteArchiveEvent>(_onToggleNoteArchive);
  }

  Future<void> _onLoadAllNotes(
    LoadAllNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());

    final result = await getAllNotes(NoParams());
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onLoadNoteById(
    LoadNoteById event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());

    final result = await getNoteById(GetNoteByIdParams(id: event.id));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (note) => emit(NoteLoaded(note)),
    );
  }

  Future<void> _onCreateNote(
    CreateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());

    const uuid = Uuid();
    final result = await createNote(CreateNoteParams(
      id: uuid.v4(),
      title: event.title,
      content: event.content,
      folderId: event.folderId,
      tags: event.tags,
      color: event.color,
    ));

    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (note) => emit(NoteCreated(note)),
    );
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());

    final result = await updateNote(UpdateNoteParams(note: event.note));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (note) => emit(NoteUpdated(note)),
    );
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());

    final result = await deleteNote(DeleteNoteParams(id: event.id));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (_) => emit(NoteDeleted(event.id)),
    );
  }

  Future<void> _onToggleNotePin(
    ToggleNotePinEvent event,
    Emitter<NotesState> emit,
  ) async {
    final updatedNote = event.note.copyWith(isPinned: !event.note.isPinned);
    final result = await updateNote(UpdateNoteParams(note: updatedNote));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (note) => emit(NoteUpdated(note)),
    );
  }

  Future<void> _onToggleNoteArchive(
    ToggleNoteArchiveEvent event,
    Emitter<NotesState> emit,
  ) async {
    final updatedNote = event.note.copyWith(isArchived: !event.note.isArchived);
    final result = await updateNote(UpdateNoteParams(note: updatedNote));
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (note) => emit(NoteUpdated(note)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/bloc/notes_bloc.dart';
import '../../../notes/presentation/bloc/notes_state.dart';
import '../../../notes/presentation/widgets/note_card.dart';

class GlobalNotesSearchDelegate extends SearchDelegate<Note?> {
  @override
  String get searchFieldLabel => 'Search notes...';

  Color _getColorFromHex(String? hex) {
    if (hex == null) return Colors.blue;
    final hexCode = hex.replaceAll('#', '');
    try {
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Enter a search term',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is NotesLoaded) {
          final filteredNotes = state.notes.where((note) {
            final searchQuery = query.toLowerCase();
            return note.title.toLowerCase().contains(searchQuery) ||
                note.content.toLowerCase().contains(searchQuery) ||
                note.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
          }).toList();

          if (filteredNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No notes found for "$query"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try searching with different keywords',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoteCard(
                  note: note,
                  onTap: () {
                    close(context, note);
                    Navigator.pushNamed(
                      context,
                      '/note-editor',
                      arguments: note,
                    );
                  },
                  onDelete: () {
                    // Delete functionality would be handled by the notes bloc
                    // For now, just close the search
                    close(context, null);
                  },
                  onTogglePin: () {
                    // TODO: Implement pin/unpin functionality
                  },
                  onToggleArchive: () {
                    // TODO: Implement archive functionality
                  },
                ),
              );
            },
          );
        }

        return const Center(
          child: Text(
            'Start searching to see results',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded && state.notes.isNotEmpty) {
            // Show recent notes as suggestions
            final recentNotes = state.notes.take(5).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Recent Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentNotes.length,
                    itemBuilder: (context, index) {
                      final note = recentNotes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getColorFromHex(note.color),
                          child: const Icon(Icons.note, color: Colors.white),
                        ),
                        title: Text(
                          note.title.isEmpty ? 'Untitled Note' : note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          note.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          query = note.title;
                          showResults(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Search your notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Enter keywords to find notes by title, content, or tags',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );
    }

    // Show suggestions based on current query
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoaded) {
          final suggestions = state.notes
              .where((note) {
                final searchQuery = query.toLowerCase();
                return note.title.toLowerCase().contains(searchQuery) ||
                    note.content.toLowerCase().contains(searchQuery);
              })
              .take(10)
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final note = suggestions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getColorFromHex(note.color),
                  child: const Icon(Icons.note, color: Colors.white),
                ),
                title: Text(
                  note.title.isEmpty ? 'Untitled Note' : note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  query = note.title;
                  showResults(context);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    query = note.title;
                    showResults(context);
                  },
                ),
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    // Trigger search when showing results
    if (query.isNotEmpty) {
      // The search will be performed by the buildResults method
      // using the existing notes loaded in the bloc
    }
    super.showResults(context);
  }
}

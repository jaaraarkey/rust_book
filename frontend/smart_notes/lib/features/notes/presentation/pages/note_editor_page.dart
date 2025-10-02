import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../../domain/entities/note.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/tag_input_widget.dart';
import '../../../../core/utils/constants.dart';
import '../../../../injection_container.dart' as di;

class NoteEditorPage extends StatefulWidget {
  final String? noteId;
  final String? folderId;

  const NoteEditorPage({super.key, this.noteId, this.folderId});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NotesBloc _notesBloc;

  Note? _currentNote;
  List<String> _tags = [];
  String? _selectedColor;
  bool _isPinned = false;
  bool _isArchived = false;
  bool _hasUnsavedChanges = false;

  final List<String> _noteColors = [
    '#FFFFFF', // White
    '#FFE4E1', // Light Pink
    '#E1F5FE', // Light Blue
    '#E8F5E8', // Light Green
    '#FFF3E0', // Light Orange
    '#F3E5F5', // Light Purple
    '#FFECB3', // Light Yellow
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _notesBloc = di.sl<NotesBloc>();

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);

    if (widget.noteId != null) {
      _notesBloc.add(LoadNoteById(widget.noteId!));
    }
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save empty note')),
      );
      return;
    }

    if (_currentNote == null) {
      // Create new note
      _notesBloc.add(CreateNoteEvent(
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        folderId: widget.folderId,
        tags: _tags,
        color: _selectedColor,
      ));
    } else {
      // Update existing note
      final updatedNote = _currentNote!.copyWith(
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        tags: _tags,
        color: _selectedColor,
        isPinned: _isPinned,
        isArchived: _isArchived,
      );
      _notesBloc.add(UpdateNoteEvent(updatedNote));
    }
  }

  void _deleteNote() {
    if (_currentNote != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _notesBloc.add(DeleteNoteEvent(_currentNote!.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  Color _getColorFromHex(String? hex) {
    if (hex == null) return Colors.white;
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notesBloc,
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NoteLoaded) {
            setState(() {
              _currentNote = state.note;
              _titleController.text = state.note.title;
              _contentController.text = state.note.content;
              _tags = List.from(state.note.tags);
              _selectedColor = state.note.color;
              _isPinned = state.note.isPinned;
              _isArchived = state.note.isArchived;
              _hasUnsavedChanges = false;
            });
          } else if (state is NoteCreated || state is NoteUpdated) {
            setState(() {
              _hasUnsavedChanges = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note saved successfully')),
            );
          } else if (state is NoteDeleted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note deleted')),
            );
          } else if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: PopScope(
          canPop: !_hasUnsavedChanges,
          onPopInvoked: (didPop) {
            if (!didPop && _hasUnsavedChanges) {
              _showUnsavedChangesDialog();
            }
          },
          child: Scaffold(
            backgroundColor: _getColorFromHex(_selectedColor),
            appBar: AppBar(
              backgroundColor: _getColorFromHex(_selectedColor),
              elevation: 0,
              title: Text(
                widget.noteId != null ? 'Edit Note' : 'New Note',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: [
                if (_currentNote != null)
                  IconButton(
                    icon: Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: _isPinned ? Colors.orange : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPinned = !_isPinned;
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                if (_currentNote != null)
                  IconButton(
                    icon: Icon(
                      _isArchived ? Icons.unarchive : Icons.archive_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isArchived = !_isArchived;
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveNote,
                ),
                if (_currentNote != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _deleteNote,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'color') {
                      _showColorPicker();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'color',
                      child: Row(
                        children: [
                          Icon(Icons.palette_outlined),
                          SizedBox(width: 8),
                          Text('Change Color'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Title Input
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Note title...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          maxLines: 2,
                        ),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Tags Input
                        TagInputWidget(
                          tags: _tags,
                          onTagsChanged: (tags) {
                            setState(() {
                              _tags = tags;
                              _hasUnsavedChanges = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Content Input
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Start writing...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Toolbar at bottom
                NoteEditorToolbar(
                  onFormatAction: (action) {
                    // Handle text formatting actions
                    _handleFormatAction(action);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleFormatAction(String action) {
    final selection = _contentController.selection;
    final text = _contentController.text;
    final start = selection.start;
    final end = selection.end;

    String newText;
    int newCursorPosition;

    switch (action) {
      case 'bold':
        newText =
            '${text.substring(0, start)}**${text.substring(start, end)}**${text.substring(end)}';
        newCursorPosition = end + 4;
        break;
      case 'italic':
        newText =
            '${text.substring(0, start)}_${text.substring(start, end)}_${text.substring(end)}';
        newCursorPosition = end + 2;
        break;
      case 'bullet':
        newText =
            '${text.substring(0, start)}\n• ${text.substring(start, end)}${text.substring(end)}';
        newCursorPosition = end + 3;
        break;
      case 'numbered':
        newText =
            '${text.substring(0, start)}\n1. ${text.substring(start, end)}${text.substring(end)}';
        newCursorPosition = end + 4;
        break;
      default:
        return;
    }

    _contentController.text = newText;
    _contentController.selection =
        TextSelection.collapsed(offset: newCursorPosition);
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: SizedBox(
          width: 250,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _noteColors.length,
            itemBuilder: (context, index) {
              final color = _noteColors[index];
              final isSelected = _selectedColor == color;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                    _hasUnsavedChanges = true;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _getColorFromHex(color),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Do you want to save before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveNote();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

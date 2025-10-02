// Authentication Queries and Mutations
const String loginMutation = '''
  mutation Login(\$input: LoginInput!) {
    login(input: \$input) {
      token
      user {
        id
        email
        fullName
        createdAt
        isActive
      }
    }
  }
''';

const String registerMutation = '''
  mutation Register(\$input: RegisterInput!) {
    register(input: \$input) {
      token
      user {
        id
        email
        fullName
        createdAt
        isActive
      }
    }
  }
''';

const String getMeQuery = '''
  query GetMe {
    me {
      id
      email
      fullName
      createdAt
      updatedAt
      isActive
    }
  }
''';

// Notes Queries and Mutations
const String getNotesQuery = '''
  query GetNotes {
    notes {
      id
      title
      content
      isPinned
      pinnedAt
      wordCount
      viewCount
      createdAt
      updatedAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String getNoteByIdQuery = '''
  query GetNoteById(\$id: ID!) {
    note(id: \$id) {
      id
      title
      content
      isPinned
      pinnedAt
      wordCount
      viewCount
      createdAt
      updatedAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String createNoteMutation = '''
  mutation CreateNote(\$input: CreateNoteInput!) {
    createNote(input: \$input) {
      id
      title
      content
      isPinned
      wordCount
      viewCount
      createdAt
      updatedAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String updateNoteMutation = '''
  mutation UpdateNote(\$id: ID!, \$input: UpdateNoteInput!) {
    updateNote(id: \$id, input: \$input) {
      id
      title
      content
      isPinned
      wordCount
      viewCount
      createdAt
      updatedAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String deleteNoteMutation = '''
  mutation DeleteNote(\$id: ID!) {
    deleteNote(id: \$id)
  }
''';

const String toggleNotePinMutation = '''
  mutation ToggleNotePin(\$noteId: ID!) {
    toggleNotePin(noteId: \$noteId) {
      id
      title
      isPinned
      pinnedAt
    }
  }
''';

const String searchNotesQuery = '''
  query SearchNotes(\$query: String!) {
    searchNotes(query: \$query) {
      id
      title
      content
      wordCount
      createdAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String getPinnedNotesQuery = '''
  query GetPinnedNotes {
    pinnedNotes {
      id
      title
      content
      isPinned
      pinnedAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

// Folders Queries and Mutations
const String getFoldersQuery = '''
  query GetFolders {
    folders {
      id
      name
      description
      color
      icon
      position
      notesCount
      isDefault
      createdAt
      updatedAt
    }
  }
''';

const String getFolderByIdQuery = '''
  query GetFolderById(\$id: ID!) {
    folder(id: \$id) {
      id
      name
      description
      color
      icon
      position
      notesCount
      isDefault
      createdAt
      updatedAt
    }
  }
''';

const String createFolderMutation = '''
  mutation CreateFolder(\$input: CreateFolderInput!) {
    createFolder(input: \$input) {
      id
      name
      description
      color
      icon
      position
      isDefault
      createdAt
      updatedAt
    }
  }
''';

const String updateFolderMutation = '''
  mutation UpdateFolder(\$id: ID!, \$input: UpdateFolderInput!) {
    updateFolder(id: \$id, input: \$input) {
      id
      name
      description
      color
      icon
      position
      updatedAt
    }
  }
''';

const String deleteFolderMutation = '''
  mutation DeleteFolder(\$id: ID!) {
    deleteFolder(id: \$id)
  }
''';

const String getNotesInFolderQuery = '''
  query GetNotesInFolder(\$folderId: ID!) {
    notesInFolder(folderId: \$folderId) {
      id
      title
      content
      isPinned
      wordCount
      createdAt
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

const String moveNoteToFolderMutation = '''
  mutation MoveNoteToFolder(\$noteId: ID!, \$input: MoveNoteInput!) {
    moveNoteToFolder(noteId: \$noteId, input: \$input) {
      id
      title
      folderId
      folder {
        id
        name
        color
        icon
      }
    }
  }
''';

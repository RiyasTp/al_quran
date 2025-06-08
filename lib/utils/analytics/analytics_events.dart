  // Predefined event names enum
  enum AnalyticsEvent {
    bookMarkAdded('book_mark_added'),
    bookMarkRemoved('book_mark_removed'),
    notesAdded('notes_added'),
    notesRemoved('notes_removed'),
    readModeEnabled('read_mode_enabled'),
    readModeDisabled('read_mode_disabled'),
    searchPerformed('search_performed'),
    ayahCopied('ayah_copied');

    final String name;
    const AnalyticsEvent(this.name);
  }

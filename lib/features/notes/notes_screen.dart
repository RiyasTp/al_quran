import 'package:al_quran/features/notes/notes_list_widget.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshNotes() async {}

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: RefreshIndicator(
        onRefresh: _refreshNotes,
        child: NotesListView(),
      ),
    );
  }
}

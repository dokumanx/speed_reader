import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speed_reader/blocs/reading_bloc/bloc.dart';
import 'package:speed_reader/pages/regular_reader_page.dart';

class ReadingListPage extends StatelessWidget {
  const ReadingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Clipboard.getData('text/plain').then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<ReadingBloc>(
                    create: (context) => ReadingBloc()
                      ..add(
                          ReadingEvent.update(words: value?.text!.split(' '))),
                    child: const RegularReaderPage(),
                  ),
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Reading List Page'),
      ),
    );
  }
}

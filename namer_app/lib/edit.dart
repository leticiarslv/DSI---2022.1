import 'package:namer_app/repository.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  String newWord = '';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Repository state = arguments['suggestions'];
    final int? index = arguments['index'];
    final String? type = arguments['type'];

    return Scaffold(
        appBar: AppBar(
          title: type == null
              ? Text('Edit the word "${state.index(index!).asPascalCase}"')
              : Text('Add word'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You need to type some name';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      newWord = value;
                    }),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: type == null
                          ? 'Write here to edit'
                          : 'Write here to add',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        if (type == null) {
                          state.changeWordByIndex(newWord, index!);
                        } else {
                          state.addWord(newWord);
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: type == null
                      ? Text(
                          'Edit ${state.index(index!).asPascalCase} to $newWord')
                      : Text('Add $newWord'),
                ),
              ],
            ),
          ),
        ));
  }
}

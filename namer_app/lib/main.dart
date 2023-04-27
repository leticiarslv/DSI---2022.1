import 'package:flutter/material.dart';
import 'package:namer_app/words.dart';
import 'package:namer_app/edit.dart';
import 'package:namer_app/repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RandomWords(),
        '/edit': (context) => const EditPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final Repository _suggestions = Repository();
  final _saved = <Word>{};
  bool card = false;

  @override
  void initState() {
    super.initState();
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 20),
              ),
            );
          });
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text("Saved suggestions"),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            body: ListView(
              children: divided,
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Some name suggestions"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: (() {
              setState(
                () {
                  if (card == false) {
                    card = true;
                  } else if (card == true) {
                    card = false;
                  }
                },
              );
            }),
            icon: const Icon(Icons.grid_view_outlined),
            tooltip: card ? 'List visualization' : 'Card Visualization',
          ),
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.save_as),
            tooltip: "Saved suggestions",
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit', arguments: {
                      'type': 'add',
                      'suggestions': _suggestions
                    }).then((_) => setState((() {})));
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ))
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: card
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _suggestions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 90,
                        mainAxisSpacing: 50),
                    itemBuilder: (context, i) {
                      if (i >= _suggestions.length) return Text('');

                      final alreadySaved =
                          _saved.contains(_suggestions.index(i));

                      return InkResponse(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit', arguments: {
                            'index': i,
                            'suggestions': _suggestions
                          }).then((_) => setState((() {})));
                        },
                        child: GridTile(
                          footer: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (alreadySaved) {
                                        _saved.remove(_suggestions.index(i));
                                      } else {
                                        _saved.add(_suggestions.index(i));
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    alreadySaved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: alreadySaved ? Colors.red : null,
                                    semanticLabel: alreadySaved
                                        ? "Removed from saved"
                                        : "Save",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (alreadySaved) {
                                        _saved.remove(_suggestions.index(i));
                                      }
                                      _suggestions.remove(i);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                          child: Text(
                            _suggestions.index(i).asPascalCase,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemBuilder: (context, i) {
                      if (i.isOdd) return const Divider();

                      final index = i ~/ 2;

                      if (index >= _suggestions.length) return const Text('');

                      final alreadySaved =
                          _saved.contains(_suggestions.index(index));

                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/edit', arguments: {
                            'index': index,
                            'suggestions': _suggestions
                          }).then((_) => setState((() {})));
                        },
                        title: Text(
                          _suggestions.index(index).asPascalCase,
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Wrap(
                          spacing: 20,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (alreadySaved) {
                                    _saved.remove(_suggestions.index(index));
                                  } else {
                                    _saved.add(_suggestions.index(index));
                                  }
                                });
                              },
                              icon: Icon(
                                alreadySaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: alreadySaved ? Colors.red : null,
                                semanticLabel: alreadySaved
                                    ? "Removed from saved"
                                    : "Save",
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (alreadySaved) {
                                    _saved.remove(_suggestions.index(index));
                                  }
                                  _suggestions.remove(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    },
                    padding: const EdgeInsets.all(16.0),
                    itemCount: 40,
                  ),
          ),
        ],
      ),
    );
  }
}
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }


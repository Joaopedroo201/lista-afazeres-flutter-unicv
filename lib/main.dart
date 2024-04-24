import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _controlador = TextEditingController();

  bool _editando = false;
  late int _indiceEditando;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
        ),
        body: Container(
          color: Colors.green[400],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controlador,
                  decoration: InputDecoration(
                    hintText: 'Nova Tarefa',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (_) {
                    _adicionarTarefa();
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Row(
                        children: [
                          Checkbox(
                            value: _tarefas[index].status,
                            onChanged: (value) {
                              setState(() {
                                _tarefas[index].status = value ?? false;
                                if (_tarefas[index].status) {
                                  _tarefas.removeAt(index);
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: _editando && _indiceEditando == index
                                ? TextField(
                                    controller: TextEditingController(
                                        text: _tarefas[index].descricao),
                                    onSubmitted: (newValue) {
                                      setState(() {
                                        _tarefas[index].descricao = newValue;
                                        _editando = false;
                                      });
                                    },
                                  )
                                : Text(
                                    _tarefas[index].descricao,
                                    style: TextStyle(color: Colors.black),
                                  ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _editando = !_editando;
                                _indiceEditando = index;
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _editando = !_editando;
                          _indiceEditando = index;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adicionarTarefa() {
    if (_controlador.text.isEmpty) {
      return;
    }
    setState(() {
      _tarefas.add(Tarefa(descricao: _controlador.text));
      _controlador.clear();
    });
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, this.status = false});
}

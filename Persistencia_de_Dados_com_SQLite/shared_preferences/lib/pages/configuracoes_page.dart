import 'package:flutter/material.dart';
import 'package:trilhaapp/services/app_storage_service.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  AppStorageService storage = AppStorageService();

  TextEditingController nomeUsuarioController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  String? nomeUsuario;
  double? altura;
  bool receberNotificacoes = false;
  bool temaEscuro = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    nomeUsuarioController.text = await storage.getConfiguracoesNomeUsuario();
    alturaController.text =
        (await (storage.getConfiguracoesAltura())).toString();
    receberNotificacoes = await storage.getConfiguracoesReceberNotificacao();
    temaEscuro = await storage.getConfiguracoesTemaEscuro();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Configurações"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Future.delayed(Duration(milliseconds: 50), () {
                Navigator.pop(context);
              });
            },
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(hintText: "Nome usuário"),
                controller: nomeUsuarioController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Altura"),
                controller: alturaController,
              ),
            ),
            SwitchListTile(
              title: const Text("Receber notificações"),
              onChanged: (bool value) {
                setState(() {
                  receberNotificacoes = value;
                });
              },
              value: receberNotificacoes,
            ),
            SwitchListTile(
              title: const Text("Tema escuro"),
              value: temaEscuro,
              onChanged: (bool value) {
                setState(() {
                  temaEscuro = value;
                });
              },
            ),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                try {
                  await storage.setConfiguracoesAltura(
                      double.parse(alturaController.text));
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Meu App"),
                        content: Text("Favor informar uma altura válida!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok"),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                await storage
                    .setConfiguracoesNomeUsuario(nomeUsuarioController.text);
                await storage
                    .setConfiguracoesReceberNotificacao(receberNotificacoes);
                await storage.setConfiguracoesTemaEscuro(temaEscuro);
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}

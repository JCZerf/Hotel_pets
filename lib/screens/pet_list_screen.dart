import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/api_service.dart';
import 'pet_form_screen.dart'; // Tela de formulário
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<PetModel>> _petsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    setState(() {
      _petsFuture = _apiService.getPets();
    });
  }

  void _navigateToForm({PetModel? dadosPets}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetFormScreen(pet: dadosPets)),
    );
    if (result == true) {
      _loadPets();
    }
  }

  void _confirmDelete(String? id) {
    if (id == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Você tem certeza que deseja apagar este cadastro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePet(id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deletePet(String id) async {
    try {
      await _apiService.deletePet(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pet removido da lista!')));
      _loadPets();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir pet: $e')));
    }
  }

  void _showPetDetails(PetModel pet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pet.nomePet),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Tutor: ${pet.nomeTutor}'),
                Text('Contato: ${pet.contatoTutor}'),
                Text('Espécie: ${pet.especie}'),
                Text('Raça: ${pet.raca}'),
                Text(
                  'Data de Entrada: ${pet.dataEntrada.toLocal().toString().split(' ')[0]}',
                ),
                Text(
                  'Data de Saída: ${pet.dataSaida != null ? pet.dataSaida!.toLocal().toString().split(' ')[0] : 'Não definida'}',
                ),
                Text(
                  'Diárias Até o Momento: ${pet.diariasAteMomento ?? 'Não disponível'}',
                ),
                Text(
                  'Diárias Totais Previstas: ${pet.diariasTotaisPrevistas ?? 'Não disponível'}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pets Hospedados')),
      body: FutureBuilder<List<PetModel>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pet cadastrado.'));
          }

          final pets = snapshot.data!;
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return ListTile(
                title: Text('Tutor: ${pet.nomeTutor}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrada: ${pet.dataEntrada.toLocal().toString().split(' ')[0]}',
                    ),
                    Text(
                      pet.dataSaida != null
                          ? 'Saída: ${pet.dataSaida!.toLocal().toString().split(' ')[0]}'
                          : 'Saída: —',
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.brown),
                      onPressed: () => _navigateToForm(dadosPets: pet),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(pet.id),
                    ),
                  ],
                ),
                onTap: () => _showPetDetails(pet),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: const Color(0xFF5D4037), // marrom estiloso
        tooltip: 'Adicionar Pet',
        elevation: 6,
        child: const FaIcon(
          FontAwesomeIcons.paw,
          color: Colors.white, // patinha branca pra destacar
        ),
      ),
    );
  }
}

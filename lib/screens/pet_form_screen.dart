import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/api_service.dart';

class PetFormScreen extends StatefulWidget {
  final PetModel? pet;
  const PetFormScreen({super.key, this.pet});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  late TextEditingController _nomeTutorController;
  late TextEditingController _contatoTutorController;
  late TextEditingController _nomePetController;
  late TextEditingController _racaController;

  String? _especieSelecionada;
  DateTime? _dataEntradaSelecionada;
  DateTime? _dataSaidaSelecionada;

  final corMarrom = const Color(0xFF5D4037);

  @override
  void initState() {
    super.initState();
    _nomeTutorController = TextEditingController(
      text: widget.pet?.nomeTutor ?? '',
    );
    _contatoTutorController = TextEditingController(
      text: widget.pet?.contatoTutor ?? '',
    );
    _nomePetController = TextEditingController(text: widget.pet?.nomePet ?? '');
    _racaController = TextEditingController(text: widget.pet?.raca ?? '');
    _especieSelecionada = widget.pet?.especie;
    _dataEntradaSelecionada = widget.pet?.dataEntrada;
    _dataSaidaSelecionada = widget.pet?.dataSaida;
  }

  @override
  void dispose() {
    _nomeTutorController.dispose();
    _contatoTutorController.dispose();
    _nomePetController.dispose();
    _racaController.dispose();
    super.dispose();
  }

  InputDecoration _customInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 18, color: corMarrom),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: corMarrom, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown.shade300, width: 1.5),
      ),
      border: const OutlineInputBorder(),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isEntrada) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color(
                0xFF5D4037,
              ), // marrom principal (topo e botões)
              onPrimary: Colors.white, // texto branco nos botões
              surface: Colors.brown.shade50, // fundo do calendário
              onSurface: const Color(0xFF5D4037), // cor dos números e texto
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF5D4037), // botões CANCELAR/OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isEntrada) {
          _dataEntradaSelecionada = picked;
        } else {
          _dataSaidaSelecionada = picked;
        }
      });
    }
  }

  Future<void> _savePet() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final petData = PetModel(
        id: widget.pet?.id,
        nomeTutor: _nomeTutorController.text,
        contatoTutor: _contatoTutorController.text,
        nomePet: _nomePetController.text,
        especie: _especieSelecionada ?? '',
        raca: _racaController.text,
        dataEntrada: _dataEntradaSelecionada ?? DateTime.now(),
        dataSaida: _dataSaidaSelecionada,
      );

      try {
        if (widget.pet == null) {
          await _apiService.addPet(petData);
        } else {
          await _apiService.updatePet(widget.pet!.id!, petData);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso!')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pet == null ? 'Cadastrar Pet' : 'Editar Cadastro do Pet',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _savePet),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeTutorController,
                      decoration: _customInputDecoration('Nome do Tutor'),
                      style: TextStyle(fontSize: 18, color: corMarrom),
                      validator: (value) =>
                          value!.isEmpty ? 'Informe o nome do tutor' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contatoTutorController,
                      decoration: _customInputDecoration('Contato do Tutor'),
                      style: TextStyle(fontSize: 18, color: corMarrom),
                      validator: (value) =>
                          value!.isEmpty ? 'Informe o contato' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nomePetController,
                      decoration: _customInputDecoration('Nome do Pet'),
                      style: TextStyle(fontSize: 18, color: corMarrom),
                      validator: (value) =>
                          value!.isEmpty ? 'Informe o nome do pet' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _especieSelecionada,
                      decoration: _customInputDecoration('Espécie'),
                      style: TextStyle(fontSize: 18, color: corMarrom),
                      items: const [
                        DropdownMenuItem(value: 'Cão', child: Text('Cão')),
                        DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                        DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                      ],
                      onChanged: (value) =>
                          setState(() => _especieSelecionada = value),
                      validator: (value) =>
                          value == null ? 'Selecione a espécie' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _racaController,
                      decoration: _customInputDecoration('Raça'),
                      style: TextStyle(fontSize: 18, color: corMarrom),
                      validator: (value) =>
                          value!.isEmpty ? 'Informe a raça' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dataEntradaSelecionada != null
                                ? 'Entrada: ${_dataEntradaSelecionada!.toLocal().toString().split(' ')[0]}'
                                : 'Data de entrada não selecionada',
                            style: TextStyle(color: corMarrom),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: corMarrom,
                          ),
                          child: const Text('Selecionar entrada'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dataSaidaSelecionada != null
                                ? 'Saída: ${_dataSaidaSelecionada!.toLocal().toString().split(' ')[0]}'
                                : 'Data de saída não selecionada',
                            style: TextStyle(color: corMarrom),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: corMarrom,
                          ),
                          child: const Text('Selecionar saída'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

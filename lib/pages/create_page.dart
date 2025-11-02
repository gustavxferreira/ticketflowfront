import 'package:flutter/material.dart';
import 'package:ticketflowfront/dto/CreatedCalledDTO.dart';
import 'package:ticketflowfront/dto/response/area_dto.dart';
import 'package:ticketflowfront/dto/response/category_dto.dart';
import 'package:ticketflowfront/dto/response/sub_category_dto.dart';
import 'package:ticketflowfront/services/api_service.dart';
import 'package:ticketflowfront/utils/tailwind_colors.dart';
import 'package:ticketflowfront/widgets/build_section.dart';

// Enums
enum Priority { baixa, media, alta }

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Dropdowns
  List<AreaDTO> areasFromApi = [];
  List<CategoryDTO> categoriesFromApi = [];
  List<SubcategoryDTO> subcategoriesFromApi = [];

  int? selectedArea;
  int? selectedCategory;
  int? selectedSubcategory;
  Priority? selectedPriority;

  @override
  void initState() {
    super.initState();
    loadAreas();
  }

  // Carrega áreas da API
  Future<void> loadAreas() async {
    try {
      final response = await ApiService.fetchCategories();
      setState(() {
        areasFromApi = response; // Deve ser List<AreaDTO>
        categoriesFromApi = [];
        subcategoriesFromApi = [];
      });
    } catch (e) {
      print('Erro ao carregar áreas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar áreas: $e')),
      );
    }
  }

  // Envia o chamado
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final calledCreateDTO = CalledCreateDTO(
      userEmail: emailController.text,
      subject: titleController.text,
      description: descriptionController.text,
      areaId: selectedArea!,
      categoryId: selectedCategory!,
      subCategoryId: selectedSubcategory!,
      evidencePath: "teste",
    );

    try {
      await ApiService.createCalled(context, calledCreateDTO);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chamado criado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar chamado: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TailwindColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Chamado')),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TailwindColors.zinc100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TailwindColors.gray200, width: 2),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Informações de Contato
                    buildSection(
                      title: 'Informações de Contato',
                      backgroundColor: TailwindColors.zinc100,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: _inputDecoration('Email'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Preencha o email' : null,
                        ),
                      ],
                    ),

                    // Classificação do Chamado
                    buildSection(
                      title: 'Classificação do Chamado',
                      backgroundColor: TailwindColors.zinc100,
                      children: [
                        // Área
                        DropdownButtonFormField<int>(
                          value: selectedArea,
                          decoration: _inputDecoration('Área'),
                          items: areasFromApi
                              .map((a) => DropdownMenuItem(
                                    value: a.id,
                                    child: Text(a.name),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedArea = v;
                              selectedCategory = null;
                              selectedSubcategory = null;
                              categoriesFromApi = areasFromApi
                                      .firstWhere((a) => a.id == v!)
                                      .categories ??
                                  [];
                              subcategoriesFromApi = [];
                            });
                          },
                          validator: (v) =>
                              v == null ? 'Selecione uma área' : null,
                        ),
                        const SizedBox(height: 12),

                        // Categoria
                        DropdownButtonFormField<int>(
                          value: selectedCategory,
                          decoration: _inputDecoration('Categoria'),
                          items: categoriesFromApi
                              .map((c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedCategory = v;
                              selectedSubcategory = null;
                              subcategoriesFromApi = categoriesFromApi
                                      .firstWhere((c) => c.id == v!)
                                      .subcategories ??
                                  [];
                            });
                          },
                          validator: (v) =>
                              v == null ? 'Selecione uma categoria' : null,
                        ),
                        const SizedBox(height: 12),

                        // Subcategoria
                        DropdownButtonFormField<int>(
                          value: selectedSubcategory,
                          decoration: _inputDecoration('Subcategoria'),
                          items: subcategoriesFromApi
                              .map((s) => DropdownMenuItem(
                                    value: s.id,
                                    child: Text(s.name),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedSubcategory = v),
                          validator: (v) =>
                              v == null ? 'Selecione uma subcategoria' : null,
                        ),
                        const SizedBox(height: 12),

                        // Prioridade
                        DropdownButtonFormField<Priority>(
                          value: selectedPriority,
                          decoration: _inputDecoration('Prioridade'),
                          items: Priority.values
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p.name),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => selectedPriority = v),
                          validator: (v) =>
                              v == null ? 'Selecione a prioridade' : null,
                        ),
                      ],
                    ),

                    // Detalhes do Problema
                    buildSection(
                      title: 'Detalhes do Problema',
                      backgroundColor: TailwindColors.zinc100,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: _inputDecoration('Título'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Preencha o título' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: _inputDecoration('Descrição'),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Preencha a descrição' : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Criar Chamado', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

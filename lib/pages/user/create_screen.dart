import 'package:flutter/material.dart';
import 'package:ticketflowfront/dto/called_create_dto.dart';
import 'package:ticketflowfront/dto/response/area_dto.dart';
import 'package:ticketflowfront/dto/response/category_dto.dart';
import 'package:ticketflowfront/dto/response/sub_category_dto.dart';
import 'package:ticketflowfront/enums/priority_enum.dart';
import 'package:ticketflowfront/utils/service_locator.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<AreaDTO> areasFromApi = [];
  List<CategoryDTO> categoriesFromApi = [];
  List<SubcategoryDTO> subcategoriesFromApi = [];

  final _formKey = GlobalKey<FormState>();

  int? selectedArea;
  int? selectedCategory;
  int? selectedSubcategory;
  Priority? selectedPriority;

  final Map<Priority, String> priorityTranslations = {
    Priority.low: 'Baixa',
    Priority.medium: 'Média',
    Priority.high: 'Alta',
  };

  @override
  void initState() {
    super.initState();
    loadAreas();
  }

  Future<void> loadAreas() async {
    final response = await categoryService.fetchCategories();

    if (!response.isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar áreas')));
      return;
    }

    setState(() {
      areasFromApi = response.data!;
      categoriesFromApi = [];
      subcategoriesFromApi = [];
    });
  }

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

    final response = await calledService.create(calledCreateDTO);

    if (!response.isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar chamado')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chamado criado com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Criar Chamado",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF001F3F),
                  Color(0xFF004F7A),
                  Color(0xFF00A3E0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(30, kToolbarHeight + 30, 30, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_task,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Detalhes do problema",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Título",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe o título' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Descrição",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe a descrição' : null,
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Classificação do chamado",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: selectedArea,
                      decoration: InputDecoration(
                        labelText: 'Área',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: areasFromApi
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedArea = v;
                          selectedCategory = null;
                          selectedSubcategory = null;
                          categoriesFromApi =
                              areasFromApi
                                  .firstWhere((a) => a.id == v!)
                                  .categories ??
                              [];
                          subcategoriesFromApi = [];
                        });
                      },
                      validator: (v) => v == null ? 'Selecione uma área' : null,
                      dropdownColor: const Color(0xFF032649),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: selectedCategory,
                      items: categoriesFromApi
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedCategory = v;
                          selectedSubcategory = null;
                          subcategoriesFromApi =
                              categoriesFromApi
                                  .firstWhere((c) => c.id == v!)
                                  .subcategories ??
                              [];
                        });
                      },
                      validator: (v) =>
                          v == null ? 'Selecione uma categoria' : null,
                      dropdownColor: const Color(0xFF032649),
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<int>(
                      value: selectedSubcategory,
                      items: subcategoriesFromApi
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.id,
                              child: Text(s.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => selectedSubcategory = v),
                      validator: (v) =>
                          v == null ? 'Selecione uma subcategoria' : null,
                      dropdownColor: const Color(0xFF032649),
                      decoration: InputDecoration(
                        labelText: 'Subcategoria',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),

                    DropdownButtonFormField<Priority>(
                      value: selectedPriority,
                      items: Priority.values
                          .map(
                            (priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priorityTranslations[priority]!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedPriority = value),
                      validator: (v) =>
                          v == null ? 'Selecione uma prioridade' : null,
                      dropdownColor: const Color(0xFF032649),
                      decoration: InputDecoration(
                        labelText: 'Prioridade',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text(
                        'Criar Chamado',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        
                        foregroundColor: Colors.white,
                    
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: const Color(0xFF00A3E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

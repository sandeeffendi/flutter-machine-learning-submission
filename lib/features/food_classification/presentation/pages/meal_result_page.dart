import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/provider/nutrition_provider.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/provider/search_meals_by_name_provider.dart';
import 'package:provider/provider.dart';

class MealResultPage extends StatefulWidget {
  final (String, String) mealName;

  const MealResultPage({super.key, required this.mealName});

  @override
  State<MealResultPage> createState() => _MealResultPageState();
}

class _MealResultPageState extends State<MealResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      if (!mounted) return;
      context.read<NutritionProvider>().getNutrition(widget.mealName.$1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SearchMealsByNameProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchMeals(widget.mealName.$1);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Consumer<SearchMealsByNameProvider>(
        builder: (context, value, child) {
          if (value.state == SearchMealsState.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (value.state == SearchMealsState.error) {
            return Center(child: Text(value.message!));
          }
          if (value.meals.isEmpty) {
            return Center(child: Text('Meals not found found.'));
          }

          final meal = value.meals.first;
          final percentage = double.parse(widget.mealName.$2) * 100;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(child: Icon(Icons.arrow_back)),
                ),

                toolbarHeight: 300,
                backgroundColor: Theme.of(context).colorScheme.primary,

                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    '${meal.thumbnail}/large',
                    fit: BoxFit.cover,
                  ),
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Text(
                      " $percentage% ${meal.name}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 2,
                title: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).round()),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelStyle: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    labelColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withAlpha((0.6 * 255).round()),
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Ingredients'),
                      Tab(text: 'Nutrition'),
                      Tab(text: 'Instruction'),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Ingridients Tab View
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              radius: const Radius.circular(8),
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: meal.ingredients.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final ingredient = meal.ingredients[index];
                                  final measure = meal.measures[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ingredient,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          measure.isNotEmpty ? measure : '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nutrition Tab View
                    Consumer<NutritionProvider>(
                      builder: (context, value, child) {
                        switch (value.state) {
                          case NutritionState.loading:
                            return Center(
                              child: const CircularProgressIndicator(),
                            );
                          case NutritionState.loaded:
                            final nutrition = value.nutrition!;
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: ListView(
                                children: [
                                  Text(
                                    'Nutrition Information',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  _NutritionRow(
                                    title: 'Calories',
                                    value: '${nutrition.calories} kcal',
                                  ),
                                  _NutritionRow(
                                    title: 'Protein',
                                    value: '${nutrition.protein} g',
                                  ),
                                  _NutritionRow(
                                    title: 'Carbs',
                                    value: '${nutrition.carbs} g',
                                  ),
                                  _NutritionRow(
                                    title: 'Fat',
                                    value: '${nutrition.fat} g',
                                  ),
                                ],
                              ),
                            );
                          case NutritionState.error:
                            return Center(
                              child: Text(
                                '${value.message}. Error to load nutrition data.',
                              ),
                            );
                          default:
                            return const Center(
                              child: Text('ini adalah default case'),
                            );
                        }
                      },
                    ),

                    // Instruction / Cara pembuatan
                    _InstructionCard(
                      instruction: meal.instructions,
                      mealName: meal.name,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String title;
  final String value;

  const _NutritionRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// Instruction card: expandable, copy, view-as-steps
class _InstructionCard extends StatefulWidget {
  final String instruction;
  final String? mealName;

  const _InstructionCard({required this.instruction, this.mealName});

  @override
  State<_InstructionCard> createState() => _InstructionCardState();
}

class _InstructionCardState extends State<_InstructionCard> {
  bool _expanded = true;
  bool _showSteps = false;

  List<String> get _steps {
    final text = widget.instruction.trim();
    if (text.isEmpty) return [];

    // Pisah menjadi kalimat/line; fallback ke newline jika ada
    final parts = text
        .split(RegExp(r'[\r\n]+|(?<=[.!?])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cara Pembuatan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy instruction',
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: widget.instruction),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Instruction copied')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Toggle: paragraph vs steps
              if (steps.length > 1)
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Paragraph'),
                      selected: !_showSteps,
                      onSelected: (v) =>
                          setState(() => _showSteps = !v ? true : false),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Steps'),
                      selected: _showSteps,
                      onSelected: (v) => setState(() => _showSteps = v),
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              // Content
              AnimatedCrossFade(
                firstChild: _buildParagraphView(context),
                secondChild: _buildStepsView(context, steps),
                crossFadeState: (_expanded
                    ? (_showSteps
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst)
                    : CrossFadeState.showFirst),
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraphView(BuildContext context) {
    final text = widget.instruction.trim();
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Text(
        text.isEmpty ? 'No instructions provided.' : text,
        maxLines: _expanded ? 100 : 4,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildStepsView(BuildContext context, List<String> steps) {
    if (steps.isEmpty) {
      return Text(
        'No instructions provided.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final s = steps[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                child: Text('${i + 1}', style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(s, style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Stat card kecil untuk angka nutrisi

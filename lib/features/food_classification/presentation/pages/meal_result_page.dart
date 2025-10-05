import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
                backgroundColor: Theme.of(context).colorScheme.primary,

                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    '${meal.thumbnail}/large',
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    " $percentage% ${meal.name}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: meal.ingredients.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 16),
                              itemBuilder: (context, index) {
                                final ingredient = meal.ingredients[index];
                                final measure = meal.measures[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                      child: const Icon(
                                        Icons.restaurant_menu,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      ingredient,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    subtitle: Text(
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
                                  ),
                                );
                              },
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

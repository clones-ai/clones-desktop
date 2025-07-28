import 'package:auto_size_text/auto_size_text.dart';
import 'package:clones_desktop/application/apps.dart';
import 'package:clones_desktop/application/settings.dart';
import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/domain/models/factory_settings.dart';
import 'package:clones_desktop/domain/models/forge_task/forge_app.dart';
import 'package:clones_desktop/domain/models/forge_task/forge_task_item.dart';
import 'package:clones_desktop/domain/models/ui/factory_filter.dart';
import 'package:clones_desktop/ui/views/factory/layouts/components/filter_panel.dart';
import 'package:clones_desktop/ui/views/factory/layouts/components/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailableTasks extends ConsumerStatefulWidget {
  const AvailableTasks({
    super.key,
    this.poolId,
  });
  final String? poolId;
  @override
  ConsumerState<AvailableTasks> createState() => _AvailableTasksState();
}

class _AvailableTasksState extends ConsumerState<AvailableTasks> {
  late FactoryFilter _filter;
  List<String> _allCategories = [];
  final Set<String> _selectedCategories = {};
  String _sort = 'htl';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _filter = const FactoryFilter();
    _fetchCategories();

    // Initialize controllers when settings are loaded
    ref.listenManual(factorySettingsNotifierProvider, (previous, next) {
      if (next.hasValue) {
        final settings = next.value!;
        _minPriceController.text = settings.minPrice.toString();
        _maxPriceController.text = settings.maxPrice.toString();
        _applyFilters();
      }
    });
  }

  Future<void> _fetchCategories() async {
    final categories = await ref.read(getFactoryCategoriesProvider.future);
    setState(() {
      _allCategories = categories;
    });
  }

  void _applyFilters() {
    final settings = ref.read(factorySettingsNotifierProvider).value ??
        const FactorySettings();
    final minPrice =
        int.tryParse(_minPriceController.text) ?? settings.minPrice;
    final maxPrice =
        int.tryParse(_maxPriceController.text) ?? settings.maxPrice;

    setState(() {
      _filter = FactoryFilter(
        poolId: widget.poolId,
        query:
            _searchController.text.isNotEmpty ? _searchController.text : null,
        categories: _selectedCategories.isNotEmpty
            ? _selectedCategories.toList()
            : null,
        minReward: minPrice,
        maxReward: maxPrice,
        hideAdult: settings.hideAdult,
      );
    });
  }

  double _getReward(ForgeApp app, ForgeTaskItem task) {
    return task.rewardLimit ?? app.poolId?.pricePerDemo ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final tasksProvider = getAppsForFactoryProvider(filter: _filter);
    final tasksAsync = ref.watch(tasksProvider);
    final settings = ref.watch(factorySettingsNotifierProvider);
    final theme = Theme.of(context);
    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text('Error loading settings: $err')),
      data: (factorySettings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(
                  'Choose a task, record a demonstration on your desktop, earn rewards.\nYour data helps us build the largest open-source dataset for training sophisticated AI assistants.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  minFontSize: 14,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildHeader(),
          if (_showFilters)
            FilterPanel(
              settings: factorySettings,
              searchController: _searchController,
              minPriceController: _minPriceController,
              maxPriceController: _maxPriceController,
              sortValue: _sort,
              onSortChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sort = value;
                  });
                }
              },
              allCategories: _allCategories,
              selectedCategories: _selectedCategories,
              onCategorySelected: (category, selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
                _applyFilters();
              },
              onSelectAllCategories: () {
                setState(_selectedCategories.clear);
                _applyFilters();
              },
              onApplyFilters: () {
                final newSettings = factorySettings.copyWith(
                  minPrice: int.tryParse(_minPriceController.text) ??
                      factorySettings.minPrice,
                  maxPrice: int.tryParse(_maxPriceController.text) ??
                      factorySettings.maxPrice,
                );
                ref
                    .read(factorySettingsNotifierProvider.notifier)
                    .saveFactorySettings(newSettings);
                _applyFilters();
              },
              onResetFilters: () {
                _searchController.clear();
                _selectedCategories.clear();
                setState(() {
                  _sort = 'htl';
                });
                ref
                    .read(factorySettingsNotifierProvider.notifier)
                    .saveFactorySettings(
                      const FactorySettings(),
                    );
                _applyFilters();
              },
            ),
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (apps) {
                if (apps.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }
                final tasks = apps
                    .expand(
                      (app) =>
                          app.tasks.map((task) => {'app': app, 'task': task}),
                    )
                    .toList()
                  ..sort((a, b) {
                    final rewardA = _getReward(
                      a['app']! as ForgeApp,
                      a['task']! as ForgeTaskItem,
                    );
                    final rewardB = _getReward(
                      b['app']! as ForgeApp,
                      b['task']! as ForgeTaskItem,
                    );
                    return _sort == 'htl'
                        ? rewardB.compareTo(rewardA)
                        : rewardA.compareTo(rewardB);
                  });

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 310,
                    childAspectRatio: 3 / 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final app = tasks[index]['app']! as ForgeApp;
                    final task = tasks[index]['task']! as ForgeTaskItem;
                    return TaskCard(app: app, task: task);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Available Tasks',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ClonesColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${ref.watch(getAppsForFactoryProvider(filter: _filter)).asData?.value.map((e) => e.tasks.length).fold(0, (a, b) => a + b) ?? 0} Available',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.keyboard_arrow_up : Icons.filter_list,
              color: ClonesColors.secondary,
            ),
            label: Text(
              'Filters',
              style: theme.textTheme.bodySmall?.copyWith(
                color: ClonesColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

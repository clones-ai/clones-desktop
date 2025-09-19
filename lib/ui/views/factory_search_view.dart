import 'package:clones_desktop/application/subgraph_provider.dart';
import 'package:clones_desktop/infrastructure/subgraph.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Factory search view using The Graph subgraph
/// Provides a desktop interface for discovering and managing factory pools
class FactorySearchView extends ConsumerStatefulWidget {
  const FactorySearchView({super.key});

  @override
  ConsumerState<FactorySearchView> createState() => _FactorySearchViewState();
}

class _FactorySearchViewState extends ConsumerState<FactorySearchView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minFundingController = TextEditingController();
  String? _selectedTokenAddress;
  String? _selectedCreatorAddress;

  PoolSearchFilters _currentFilters = const PoolSearchFilters();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minFundingController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many requests
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _searchController.text.isNotEmpty) {
        _performSearch();
      }
    });
  }

  void _performSearch() {
    final newFilters = PoolSearchFilters(
      searchText:
          _searchController.text.isEmpty ? null : _searchController.text,
      tokenAddress: _selectedTokenAddress,
      creatorAddress: _selectedCreatorAddress,
      minFunding: _minFundingController.text.isEmpty
          ? null
          : _minFundingController.text,
    );

    if (newFilters != _currentFilters) {
      setState(() {
        _currentFilters = newFilters;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _minFundingController.clear();
      _selectedTokenAddress = null;
      _selectedCreatorAddress = null;
      _currentFilters = const PoolSearchFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch factory overview for statistics
    final factoryOverviewAsync = ref.watch(factoryOverviewProvider);

    // Watch pool search results
    final poolSearchAsync = ref.watch(poolSearchProvider(_currentFilters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factory Pool Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                ..invalidate(factoryOverviewProvider)
                ..invalidate(poolSearchProvider(_currentFilters));
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          // Factory Overview Statistics
          _buildFactoryOverview(factoryOverviewAsync),

          // Search Filters
          _buildSearchFilters(),

          // Pool Results
          Expanded(
            child: _buildPoolResults(poolSearchAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildFactoryOverview(
    AsyncValue<FactoryOverview> factoryOverviewAsync,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Factory Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            factoryOverviewAsync.when(
              data: _buildFactoryStats,
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(
                'Error loading overview: $error',
                style: TextStyle(color: Colors.red[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactoryStats(FactoryOverview overview) {
    final stats = overview.factoryStats;
    if (stats == null) return const Text('No statistics available');

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildStatChip('Total Pools', stats.totalPools),
        _buildStatChip('Total Volume', _formatBigInt(stats.totalVolume)),
        _buildStatChip('Total Fees', _formatBigInt(stats.totalFees)),
        _buildStatChip('Total Users', stats.totalUsers),
        _buildStatChip('Total Claims', stats.totalClaims),
      ],
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget _buildSearchFilters() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Search Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Search Text
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search pools...',
                      hintText: 'Pool description, skills',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Min Funding
                Expanded(
                  child: TextField(
                    controller: _minFundingController,
                    decoration: const InputDecoration(
                      labelText: 'Min Funding',
                      hintText: '0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 16),

                // Search Button
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolResults(AsyncValue<List<PoolSearchResult>> poolSearchAsync) {
    return poolSearchAsync.when(
      data: _buildPoolsList,
      loading: () => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 0.5,
        ),
      ),
      error: (error, stackTrace) => _buildErrorWidget(error),
    );
  }

  Widget _buildPoolsList(List<PoolSearchResult> pools) {
    if (pools.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No pools found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Try adjusting your search filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: pools.length,
      itemBuilder: (context, index) {
        final pool = pools[index];
        return _buildPoolCard(pool);
      },
    );
  }

  Widget _buildPoolCard(PoolSearchResult pool) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: pool.isActive ? Colors.green[100] : Colors.grey[300],
          child: Text(
            pool.token.symbol,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: pool.isActive ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ),
        title: Text(
          pool.description ?? 'Pool ${_formatAddress(pool.id)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Creator: ${_formatAddress(pool.creator)}'),
            Text('Token: ${pool.token.name} (${pool.token.symbol})'),
            Row(
              children: [
                Text('Funded: ${_formatBigInt(pool.totalFunded)}'),
                const SizedBox(width: 16),
                Text('Users: ${pool.totalUsers}'),
                const SizedBox(width: 16),
                Text('Claims: ${pool.totalClaims}'),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              pool.isActive ? Icons.check_circle : Icons.pause_circle,
              color: pool.isActive ? Colors.green : Colors.orange,
            ),
            Text(
              _formatTimestamp(pool.lastActivityAt),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        onTap: () => _viewPoolDetails(pool),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading pools',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(poolSearchProvider(_currentFilters));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _viewPoolDetails(PoolSearchResult pool) {
    showDialog(
      context: context,
      builder: (context) => _PoolDetailsDialog(poolId: pool.id),
    );
  }

  String _formatAddress(String address) {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  String _formatBigInt(String value) {
    try {
      final bigInt = BigInt.parse(value);
      if (bigInt >= BigInt.from(1000000000000000000)) {
        return '${bigInt / BigInt.from(1000000000000000000)}e18';
      } else if (bigInt >= BigInt.from(1000000)) {
        return '${bigInt / BigInt.from(1000000)}M';
      } else if (bigInt >= BigInt.from(1000)) {
        return '${bigInt / BigInt.from(1000)}K';
      }
      return bigInt.toString();
    } catch (e) {
      return value;
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Dialog for showing detailed pool information
class _PoolDetailsDialog extends ConsumerWidget {
  const _PoolDetailsDialog({required this.poolId});
  final String poolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolDetailsAsync = ref.watch(poolDetailsProvider(poolId));

    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Pool Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: poolDetailsAsync.when(
                data: (poolDetails) {
                  if (poolDetails == null) {
                    return const Center(child: Text('Pool not found'));
                  }
                  return _buildPoolDetailsContent(poolDetails);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 0.5,
                  ),
                ),
                error: (error, _) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolDetailsContent(PoolDetails details) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info
          _buildSection('Basic Information', [
            _buildInfoRow('Pool ID', _formatAddress(details.id)),
            _buildInfoRow('Creator', _formatAddress(details.creator)),
            _buildInfoRow(
              'Token',
              '${details.token.name} (${details.token.symbol})',
            ),
            _buildInfoRow('Factory', _formatAddress(details.factory.id)),
            _buildInfoRow('Status', details.isActive ? 'Active' : 'Inactive'),
          ]),

          // Statistics
          _buildSection('Statistics', [
            _buildInfoRow('Total Funded', _formatBigInt(details.totalFunded)),
            _buildInfoRow('Total Claimed', _formatBigInt(details.totalClaimed)),
            _buildInfoRow('Total Fees', _formatBigInt(details.totalFees)),
            _buildInfoRow('Total Users', details.totalUsers),
            _buildInfoRow('Total Claims', details.totalClaims),
          ]),

          // Recent Activity
          if (details.claims.isNotEmpty)
            _buildSection(
              'Recent Claims',
              details.claims
                  .map(
                    (claim) => _buildInfoRow(
                      _formatAddress(claim.user.id),
                      '${_formatBigInt(claim.netAmount)} ${details.token.symbol}',
                    ),
                  )
                  .toList(),
            ),

          if (details.fundings.isNotEmpty)
            _buildSection(
              'Recent Fundings',
              details.fundings
                  .map(
                    (funding) => _buildInfoRow(
                      _formatAddress(funding.funder.id),
                      '${_formatBigInt(funding.amount)} ${details.token.symbol}',
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  String _formatBigInt(String value) {
    try {
      final bigInt = BigInt.parse(value);
      if (bigInt >= BigInt.from(1000000000000000000)) {
        return '${bigInt / BigInt.from(1000000000000000000)}e18';
      } else if (bigInt >= BigInt.from(1000000)) {
        return '${bigInt / BigInt.from(1000000)}M';
      } else if (bigInt >= BigInt.from(1000)) {
        return '${bigInt / BigInt.from(1000)}K';
      }
      return bigInt.toString();
    } catch (e) {
      return value;
    }
  }
}

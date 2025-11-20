import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lead_provider.dart';
import '../utils/constants.dart';
import '../widgets/lead_card.dart';
import 'add_lead_screen.dart';
import 'lead_detail_screen.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeadProvider>().loadLeads();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Manager'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search leads...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<LeadProvider>().searchLeads('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                context.read<LeadProvider>().searchLeads(value);
              },
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: Consumer<LeadProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: AppConstants.filterList.length,
                  itemBuilder: (context, index) {
                    final filter = AppConstants.filterList[index];
                    final isSelected = provider.currentFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          provider.filterLeads(filter);
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Leads List
          Expanded(
            child: Consumer<LeadProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.leads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No leads found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first lead to get started',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.leads.length,
                  itemBuilder: (context, index) {
                    final lead = provider.leads[index];
                    return LeadCard(
                      lead: lead,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadDetailScreen(lead: lead),
                          ),
                        );
                        provider.loadLeads();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLeadScreen()),
          );
          context.read<LeadProvider>().loadLeads();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Lead'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../utils/constants.dart';
import '../widgets/status_badge.dart';

class LeadDetailScreen extends StatefulWidget {
  final Lead lead;

  const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _notesController;
  late String _selectedStatus;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.lead.name);
    _contactController = TextEditingController(text: widget.lead.contact);
    _notesController = TextEditingController(text: widget.lead.notes ?? '');
    _selectedStatus = widget.lead.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateLead() async {
    if (_nameController.text.trim().isEmpty ||
        _contactController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Contact are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedLead = widget.lead.copyWith(
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        status: _selectedStatus,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await context.read<LeadProvider>().updateLead(updatedLead);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead updated successfully')),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteLead() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: const Text('Are you sure you want to delete this lead?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<LeadProvider>().deleteLead(widget.lead.id!);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lead deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteLead,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Badge (Always Visible)
            if (!_isEditing) ...[
              Center(child: StatusBadge(status: widget.lead.status)),
              const SizedBox(height: 24),
            ],

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                enabled: _isEditing,
              ),
            ),
            const SizedBox(height: 16),

            // Contact Field
            TextFormField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Contact',
                prefixIcon: const Icon(Icons.contact_phone),
                border: const OutlineInputBorder(),
                enabled: _isEditing,
              ),
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            if (_isEditing)
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Status'),
                subtitle: Text(_selectedStatus),
                contentPadding: EdgeInsets.zero,
              ),
            const SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                prefixIcon: const Icon(Icons.notes),
                border: const OutlineInputBorder(),
                enabled: _isEditing,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Timestamps
            if (!_isEditing) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Created'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy HH:mm').format(widget.lead.createdAt),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Last Updated'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy HH:mm').format(widget.lead.updatedAt),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],

            // Action Buttons
            if (_isEditing) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isEditing = false;
                                _nameController.text = widget.lead.name;
                                _contactController.text = widget.lead.contact;
                                _notesController.text = widget.lead.notes ?? '';
                                _selectedStatus = widget.lead.status;
                              });
                            },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateLead,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

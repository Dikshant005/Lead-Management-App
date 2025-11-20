import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/lead_provider.dart';
import '../utils/constants.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({Key? key}) : super(key: key);

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedStatus = AppConstants.statusNew;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveLead() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final lead = Lead(
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        status: _selectedStatus,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await context.read<LeadProvider>().addLead(lead);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead added successfully')),
        );
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter lead name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Field
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact *',
                  hintText: 'Phone or Email',
                  prefixIcon: Icon(Icons.contact_phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Contact is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
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
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add description or notes',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveLead,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save Lead',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

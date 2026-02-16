import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/api_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _submissionsController = TextEditingController();
  
  String _taskType = 'IMAGE';
  final List<PlatformFile> _selectedFiles = [];
  bool _isSubmitting = false;

  final List<String> _taskTypes = [
    'IMAGE',
    'TEXT',
    'AUDIO',
    'VIDEO',
    'DATA_ENTRY',
  ];

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picking failed: $e')),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Note: File upload is not yet implemented
      // TODO: Implement file upload using StorageService when needed

      await _apiService.createTask({
        'title': _titleController.text.trim(),
        'task_type': _taskType,
        'instructions': _instructionsController.text.trim(),
        'pay_per_task': double.parse(_payController.text),
        'required_submissions': int.parse(_submissionsController.text),
        'status': 'ACTIVE',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task creation failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Label images of cats and dogs',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Task Type
              DropdownButtonFormField<String>(
                value: _taskType,
                decoration: const InputDecoration(
                  labelText: 'Task Type',
                  border: OutlineInputBorder(),
                ),
                items: _taskTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _taskType = value!);
                },
              ),
              const SizedBox(height: 16),

              // Instructions
              TextFormField(
                controller: _instructionsController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(),
                  hintText: 'Provide clear instructions for workers...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pay per task
              TextFormField(
                controller: _payController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pay per Task (\$)',
                  border: OutlineInputBorder(),
                  hintText: '0.10',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter payment amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Required submissions
              TextFormField(
                controller: _submissionsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Submissions Needed',
                  border: OutlineInputBorder(),
                  hintText: '100',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter number of submissions';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // File Upload Section
              const Text(
                'Task Files (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Files'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 8),
              
              // Selected files list
              if (_selectedFiles.isNotEmpty) ...[
                const Text('Selected Files:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._selectedFiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final file = entry.value;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.file_present),
                      title: Text(file.name),
                      subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _removeFile(index),
                      ),
                    ),
                  );
                }).toList(),
              ],
              const SizedBox(height: 24),

              // Estimated Cost
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Cost',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _calculateEstimatedCost(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateEstimatedCost() {
    final pay = double.tryParse(_payController.text) ?? 0;
    final submissions = int.tryParse(_submissionsController.text) ?? 0;
    final total = pay * submissions;
    return '\$${total.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _payController.dispose();
    _submissionsController.dispose();
    super.dispose();
  }
}

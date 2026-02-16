import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ReviewSubmissionsScreen extends StatefulWidget {
  final String taskId;

  const ReviewSubmissionsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<ReviewSubmissionsScreen> createState() => _ReviewSubmissionsScreenState();
}

class _ReviewSubmissionsScreenState extends State<ReviewSubmissionsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _submissions = [];
  Map<String, dynamic>? _task;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final submissions = await _apiService.getTaskSubmissions(widget.taskId);
      final task = await _apiService.getTaskDetails(widget.taskId);
      
      setState(() {
        _submissions = submissions;
        _task = task;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _approveSubmission(String submissionId) async {
    try {
      await _apiService.approveSubmission(submissionId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submission approved!'),
          backgroundColor: Colors.green,
        ),
      );
      
      _loadSubmissions(); // Reload
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Approval failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectSubmission(String submissionId) async {
    final TextEditingController reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Submission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && reasonController.text.trim().isNotEmpty) {
      try {
        await _apiService.rejectSubmission(submissionId, reasonController.text.trim());
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission rejected'),
            backgroundColor: Colors.orange,
          ),
        );
        
        _loadSubmissions(); // Reload
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rejection failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Submissions'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSubmissions,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Task Summary Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border(
                          bottom: BorderSide(color: Colors.blue[100]!),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _task?['title'] ?? 'Task',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatChip(
                                'Total',
                                _submissions.length.toString(),
                                Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              _buildStatChip(
                                'Pending',
                                _submissions.where((s) => s['status'] == 'PENDING').length.toString(),
                                Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              _buildStatChip(
                                'Approved',
                                _submissions.where((s) => s['status'] == 'APPROVED').length.toString(),
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Submissions List
                    Expanded(
                      child: _submissions.isEmpty
                          ? const Center(
                              child: Text('No submissions yet'),
                            )
                          : ListView.builder(
                              itemCount: _submissions.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final submission = _submissions[index];
                                return _SubmissionReviewCard(
                                  submission: submission,
                                  onApprove: () => _approveSubmission(submission['id']),
                                  onReject: () => _rejectSubmission(submission['id']),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionReviewCard extends StatelessWidget {
  final Map<String, dynamic> submission;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _SubmissionReviewCard({
    required this.submission,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final status = submission['status'] ?? 'PENDING';
    final isPending = status == 'PENDING';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    (submission['worker']?['full_name'] ?? 'W')[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        submission['worker']?['full_name'] ?? 'Worker',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        submission['worker']?['email'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Response:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              submission['response'] ?? 'No response provided',
              style: const TextStyle(fontSize: 14),
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'APPROVED':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'REJECTED':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'PENDING':
      default:
        color = Colors.orange;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Client Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover and Avatar
              Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text('Upload Cover', style: TextStyle(color: Colors.black54))),
                  ),
                  Positioned(
                    left: 24,
                    bottom: -32,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    bottom: -24,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {},
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.upload, size: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 56),
              Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _ProfileField(label: 'Full Name', initialValue: 'John Doe'),
              _ProfileField(label: 'Position', initialValue: 'CEO / Project Manager'),
              _ProfileField(label: 'Location', initialValue: 'New York, USA'),
              _ProfileField(label: 'Phone Number', initialValue: '+254746221954'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String initialValue;
  const _ProfileField({required this.label, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

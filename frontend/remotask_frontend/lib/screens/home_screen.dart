import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              // Header
              Text('Find the perfect', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
              Text('freelancer for your project', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
              SizedBox(height: 12),
              Text('Connect with top talent worldwide. Post your project, receive proposals, and hire the best freelancers.', style: TextStyle(color: Colors.black54)),
              SizedBox(height: 24),
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: StatCard(icon: Icons.trending_up, label: 'Projects Completed', value: '10M+', color: Colors.blue)),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(icon: Icons.access_time, label: 'Support Available', value: '24/7', color: Colors.indigo)),
                  SizedBox(width: 12),
                  Expanded(child: StatCard(icon: Icons.emoji_events, label: 'Client Satisfaction', value: '99%', color: Colors.amber)),
                ],
              ),
              SizedBox(height: 32),
              // Browse by Category
              Text('Browse by Category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Explore thousands of skilled professionals in every field', style: TextStyle(color: Colors.black54)),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CategoryCard(icon: Icons.language, title: 'Web Development', subtitle: '2,340 experts', color: Colors.blue),
                  CategoryCard(icon: Icons.phone_iphone, title: 'Mobile Development', subtitle: '1,120 experts', color: Colors.purple),
                  CategoryCard(icon: Icons.palette, title: 'Design & Creative', subtitle: '1,890 experts', color: Colors.pink),
                  CategoryCard(icon: Icons.description, title: 'Writing & Content', subtitle: '980 experts', color: Colors.amber),
                  CategoryCard(icon: Icons.campaign, title: 'Marketing', subtitle: '750 experts', color: Colors.green),
                  CategoryCard(icon: Icons.videocam, title: 'Video & Animation', subtitle: '620 experts', color: Colors.redAccent),
                  CategoryCard(icon: Icons.bar_chart, title: 'Data & Analytics', subtitle: '430 experts', color: Colors.indigo),
                  CategoryCard(icon: Icons.memory, title: 'AI & Machine Learning', subtitle: '310 experts', color: Colors.cyan),
                ],
              ),
              SizedBox(height: 32),
              // Call to Action
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text('Ready to get started?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Join thousands of businesses and freelancers who trust FreelanceHub to make work happen.', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
                          child: Text('Post a Project'),
                        ),
                        SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white)),
                          child: Text('Find Work', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

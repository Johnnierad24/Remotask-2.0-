import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryPurple, AppTheme.accentBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Client Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Manage your projects and find talent',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Project button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text('Post Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildDashboardStatCard(
                        icon: Icons.folder_outlined,
                        title: 'Total Projects',
                        value: '0',
                        subtitle: '0 active',
                        color: AppTheme.accentBlue,
                      ),
                      _buildDashboardStatCard(
                        icon: Icons.people_outline,
                        title: 'Proposals',
                        value: '0',
                        subtitle: 'From freelancers',
                        color: AppTheme.primaryPurple,
                      ),
                      _buildDashboardStatCard(
                        icon: Icons.attach_money,
                        title: 'Active Budget',
                        value: '\$0',
                        subtitle: 'In escrow',
                        color: AppTheme.successGreen,
                      ),
                      _buildDashboardStatCard(
                        icon: Icons.trending_up,
                        title: 'Success Rate',
                        value: '100%',
                        subtitle: 'Completed',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Give Feedback button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: AppTheme.accentBlue),
                        SizedBox(width: 12),
                        Text(
                          'Give Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Recent Projects Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Projects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text('View all'),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your latest project postings',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Empty state
                  Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 64,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No projects yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Post your first project to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  
                  // Browse by Category
                  Text(
                    'Browse by Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore thousands of skilled professionals in every field',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      CategoryCard(
                        icon: Icons.language,
                        title: 'Web Development',
                        subtitle: '2,340 experts',
                        color: AppTheme.accentBlue,
                      ),
                      CategoryCard(
                        icon: Icons.phone_iphone,
                        title: 'Mobile Development',
                        subtitle: '1,120 experts',
                        color: AppTheme.primaryPurple,
                      ),
                      CategoryCard(
                        icon: Icons.palette,
                        title: 'Design & Creative',
                        subtitle: '1,890 experts',
                        color: Colors.pink,
                      ),
                      CategoryCard(
                        icon: Icons.description,
                        title: 'Writing & Content',
                        subtitle: '980 experts',
                        color: Colors.amber,
                      ),
                      CategoryCard(
                        icon: Icons.campaign,
                        title: 'Marketing',
                        subtitle: '750 experts',
                        color: AppTheme.successGreen,
                      ),
                      CategoryCard(
                        icon: Icons.videocam,
                        title: 'Video & Animation',
                        subtitle: '620 experts',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDashboardStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

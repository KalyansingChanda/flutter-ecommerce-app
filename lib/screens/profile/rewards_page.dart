import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final int _currentPoints = 2450;
  final int _totalEarned = 8900;
  
  final List<Map<String, dynamic>> _rewardHistory = [
    {
      'type': 'earned',
      'points': 150,
      'description': 'Order completed - #ORD001',
      'date': '2024-03-10',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
    },
    {
      'type': 'redeemed',
      'points': -200,
      'description': 'Discount coupon redeemed',
      'date': '2024-03-08',
      'icon': Icons.redeem,
      'color': Colors.red,
    },
    {
      'type': 'earned',
      'points': 100,
      'description': 'Daily check-in bonus',
      'date': '2024-03-07',
      'icon': Icons.event_available,
      'color': Colors.blue,
    },
    {
      'type': 'earned',
      'points': 300,
      'description': 'First order bonus',
      'date': '2024-03-05',
      'icon': Icons.celebration,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _availableRewards = [
    {
      'title': '₹50 Off Coupon',
      'points': 500,
      'description': 'Get ₹50 off on orders above ₹999',
      'color': Colors.green,
      'icon': Icons.local_offer,
      'available': true,
    },
    {
      'title': '₹100 Off Coupon',
      'points': 1000,
      'description': 'Get ₹100 off on orders above ₹1999',
      'color': Colors.blue,
      'icon': Icons.local_offer,
      'available': true,
    },
    {
      'title': 'Free Delivery',
      'points': 200,
      'description': 'Free delivery on your next order',
      'color': Colors.orange,
      'icon': Icons.local_shipping,
      'available': true,
    },
    {
      'title': '₹200 Off Coupon',
      'points': 2000,
      'description': 'Get ₹200 off on orders above ₹3999',
      'color': Colors.purple,
      'icon': Icons.local_offer,
      'available': true,
    },
    {
      'title': 'Premium Membership',
      'points': 5000,
      'description': 'Get premium membership for 1 month',
      'color': Colors.amber,
      'icon': Icons.workspace_premium,
      'available': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Rewards & Points'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showRewardsInfo(),
            icon: const Icon(Icons.info_outline),
            tooltip: 'How it works',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPointsCard(),
                const SizedBox(height: 24),
                _buildRewardsSection(),
                const SizedBox(height: 24),
                _buildHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Points Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Earn more points with every purchase!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPointsStat('Current Points', '$_currentPoints', Icons.account_balance_wallet),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildPointsStat('Total Earned', '$_totalEarned', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Available Rewards',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _availableRewards.length,
            itemBuilder: (context, index) {
              final reward = _availableRewards[index];
              return _buildRewardCard(reward);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    final canRedeem = _currentPoints >= reward['points'] && reward['available'];
    
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: reward['color'].withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Icon(
                  reward['icon'],
                  color: reward['color'],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  reward['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reward['description'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    children: [
                      Text(
                        '${reward['points']} Points',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canRedeem ? () => _redeemReward(reward) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canRedeem ? reward['color'] : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            canRedeem ? 'Redeem' : reward['available'] ? 'Not Enough' : 'Unavailable',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Points History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _rewardHistory.length,
          itemBuilder: (context, index) {
            final item = _rewardHistory[index];
            return _buildHistoryItem(item);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: item['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item['icon'],
            color: item['color'],
            size: 20,
          ),
        ),
        title: Text(
          item['description'],
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          item['date'],
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Text(
          '${item['points'] > 0 ? '+' : ''}${item['points']}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: item['points'] > 0 ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  void _redeemReward(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              reward['icon'],
              color: reward['color'],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text('Redeem ${reward['title']}?'),
            const SizedBox(height: 8),
            Text(
              'This will cost ${reward['points']} points',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${reward['title']} redeemed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  void _showRewardsInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How Rewards Work'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📱 Earn Points:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Complete orders: 5% of order value'),
              Text('• Daily check-in: 100 points'),
              Text('• First order: 300 bonus points'),
              SizedBox(height: 16),
              Text('🎁 Redeem Points:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Use points for discounts'),
              Text('• Get free delivery'),
              Text('• Unlock premium features'),
              SizedBox(height: 16),
              Text('💡 Pro Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Points never expire'),
              Text('• Bigger orders = more points'),
              Text('• Check daily for bonus points'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
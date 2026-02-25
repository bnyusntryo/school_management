import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        title: const Text(
          'Schedule Class',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 30),

            _buildSectionHeader('Group Task'),
            const SizedBox(height: 15),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) => _buildGroupTaskCard(),
              ),
            ),
            const SizedBox(height: 30),

            _buildSectionHeader('All tasks'),
            const SizedBox(height: 15),
            _buildAllTaskItem('Create prototype', 'Projects', Colors.orange),
            _buildAllTaskItem('Create prototype', 'Projects', Colors.orange),
            _buildAllTaskItem('Create prototype', 'Projects', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
        ),
        Text(
          'See all',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final List<Map<String, String>> dates = [
      {'day': 'Fri', 'date': '11'},
      {'day': 'Sat', 'date': '12'},
      {'day': 'Sun', 'date': '14', 'active': 'true'},
      {'day': 'Mon', 'date': '14'},
      {'day': 'Tue', 'date': '15'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aug 2023',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 65,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final bool isActive = date.containsKey('active');
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue.withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isActive ? Colors.blue.withOpacity(0.3) : Colors.grey[300]!)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(date['day']!, style: TextStyle(color: isActive ? Colors.blue : Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(date['date']!, style: TextStyle(color: isActive ? Colors.blue : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTaskCard() {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.blue, size: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Presentasi\nPengantar\nAkutansi II',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const Spacer(),
          Row(
            children: [
              const Text('Members', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const Spacer(),
              SizedBox(
                width: 70,
                child: Stack(
                  children: List.generate(4, (i) => Positioned(
                    left: i * 15.0,
                    child: CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${i+20}')),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllTaskItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Row(
        children: [
          Container(width: 4, height: 35, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

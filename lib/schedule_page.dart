import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Schedule Class',
          style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2D3142), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER BULAN ---
            const Text(
              'Aug 2023',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 20),

            // --- DATE SELECTOR ---
            _buildDateSelector(),
            const SizedBox(height: 35),

            // --- SECTION HEADER (All tasks) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'See all',
                    style: TextStyle(fontSize: 14, color: Colors.indigo.shade400, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildAllTaskItem(
              title: 'Create prototype',
              subtitle1: 'Pak Hambali',
              subtitle2: 'Sedang Berlangsung',
              lineColor: const Color(0xFF2ECC71),
              avatarCount: 1,
            ),
            _buildAllTaskItem(
              title: 'Create prototype',
              subtitle1: 'Pak Hambali',
              subtitle2: 'Sedang Berlangsung',
              lineColor: const Color(0xFF2ECC71),              avatarCount: 0,
            ),
            _buildAllTaskItem(
              title: 'Create prototype',
              subtitle1: 'Pak Hambali',
              subtitle2: '11:00 - 17:00',
              lineColor: const Color(0xFFFF8A65),
              avatarCount: 2,
            ),
            _buildAllTaskItem(
              title: 'Create prototype',
              subtitle1: 'Pak Hambali',
              subtitle2: '11:00 - 17:00',
              lineColor: const Color(0xFFFF8A65),
              avatarCount: 0,
            ),
            _buildAllTaskItem(
              title: 'Create prototype',
              subtitle1: 'Pak Hambali',
              subtitle2: '11:00 - 17:00',
              lineColor: const Color(0xFFFF8A65),
              avatarCount: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final List<Map<String, dynamic>> dates = [
      {'day': 'Fri', 'date': '11', 'isActive': false},
      {'day': 'Sat', 'date': '12', 'isActive': false},
      {'day': 'Sun', 'date': '14', 'isActive': true},
      {'day': 'Mon', 'date': '14', 'isActive': false},
      {'day': 'Tue', 'date': '15', 'isActive': false},
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final bool isActive = date['isActive'];

          return Container(
            width: 65,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFD6E4FF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? Colors.transparent : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    date['day']!,
                    style: TextStyle(
                      color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    )
                ),
                const SizedBox(height: 5),
                Text(
                    date['date']!,
                    style: TextStyle(
                      color: isActive ? Colors.blue.shade800 : const Color(0xFF2D3142),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllTaskItem({
    required String title,
    required String subtitle1,
    required String subtitle2,
    required Color lineColor,
    required int avatarCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200, width: 1.5), // Subtle border
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 5)
            )
          ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 4,
              height: 45,
              decoration: BoxDecoration(
                  color: lineColor,
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF2D3142))
                    ),
                    const SizedBox(width: 8),
                    if (avatarCount > 0) _buildStackedAvatars(avatarCount),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                    subtitle1,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 2),
                Text(
                    subtitle2,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500)
                ),
              ],
            ),
          ),

          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.chat_bubble_outline_rounded, size: 28, color: Colors.grey.shade600),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text("2", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              )
            ],
          ),
          const SizedBox(width: 15),

          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1.5)
            ),
            child: Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(int count) {
    return SizedBox(
      width: 24.0 + (count - 1) * 12.0,
      height: 24,
      child: Stack(
        children: List.generate(count, (i) => Positioned(
          left: i * 12.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${i + 12}')
            ),
          ),
        )),
      ),
    );
  }
}
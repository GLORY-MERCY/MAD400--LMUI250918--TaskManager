import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 20),

            // Profile avatar 
            const CircleAvatar(
              radius: 50,
              child: Text(
                'NG',           
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            // Full name
            const Text(
              'Nnoubisi GloryMercy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // Student ID
            const Text(
              'Matricule: LMUI250918', 
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 4),

            // Programme
            const Text(
              'BTech. Software Engineering', 
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Bio section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'I am a passionate software engineering student with a love for coding and problem-solving. I enjoy building applications that make a difference and am always eager to learn new technologies. In my free time, I like to explore open-source projects and contribute to the developer community.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              ' I love reading books in a whole not only about my field of studie. Also i enjoy listening good to music.', 
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 24),

            // Semester goals section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Top 3 Goals This Semester',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // Goal 1
            _buildGoalTile(
              number: '1',
              goal: 'Gain valuable skills',  
            ),

            // Goal 2
            _buildGoalTile(
              number: '2',
              goal: 'Have impressive grades',
            ),

            // Goal 3
            _buildGoalTile(
              number: '3',
              goal: 'Graduate with first class',  
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build each goal tile
  Widget _buildGoalTile({required String number, required String goal}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(number),
        ),
        title: Text(goal),
      ),
    );
  }
}
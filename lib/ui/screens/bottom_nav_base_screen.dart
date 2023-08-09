import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_app/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app/ui/screens/in_progress_task_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_screen.dart';

class BottomNavBaseScreen extends StatefulWidget {
  const BottomNavBaseScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBaseScreen> createState() => _BottomNavBaseScreenState();
}

class _BottomNavBaseScreenState extends State<BottomNavBaseScreen> {
  int screenIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    InProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        onTap: (int index){
          screenIndex = index;
          if(mounted)
            {
              setState(() {});
            }
        },
        //backgroundColor: Colors.green,
        elevation: 10,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_label), label: 'New Task'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Completed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'Progress'),
        ],
      ),
    );
  }
}

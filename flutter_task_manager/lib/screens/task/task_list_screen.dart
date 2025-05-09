import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = [];
  TextEditingController searchController = TextEditingController();

  // Danh sách màu sắc cho các công việc
  final List<Color> taskColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
    Colors.pink.shade100,
    Colors.cyan.shade100,
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
    searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadTasks() async {
    final taskList = await TaskService.getAllTasks();
    setState(() {
      tasks = taskList;
      filteredTasks = taskList;
    });
  }

  void _filterTasks() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTasks = tasks.where((task) {
        final title = task.title?.toLowerCase() ?? '';
        final description = task.description?.toLowerCase() ?? '';
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  // Hàm xử lý đăng xuất
  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Tắt mũi tên quay lại
        title: Text(
          'Danh sách công việc Cần Làm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      searchController.text.isEmpty
                          ? 'Chưa có công việc'
                          : 'Không tìm thấy công việc',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredTasks.length,
                itemBuilder: (_, index) {
                  final task = filteredTasks[index];
                  // Chọn màu từ danh sách dựa trên chỉ số
                  final taskColor = taskColors[index % taskColors.length];
                  return Dismissible(
                    key: Key(task.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      await TaskService.deleteTask(task.id!);
                      loadTasks();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xóa công việc'),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: taskColor, // Áp dụng màu cho Card
                      child: TaskItem(
                        task: task,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/task-detail',
                            arguments: task,
                          ).then((_) => loadTasks());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/task-form').then((_) => loadTasks());
        },
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 28),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
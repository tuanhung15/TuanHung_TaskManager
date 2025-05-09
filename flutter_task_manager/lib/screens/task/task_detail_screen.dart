import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          task.title ?? 'Chi tiết công việc',
          style: const TextStyle(
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.info, color: Colors.blue.shade600),
                        title: Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          task.status ?? 'Không xác định',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.blue.shade600),
                        title: Text(
                          'Mô tả',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          task.description ?? 'Không có mô tả',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue.shade600),
                        title: Text(
                          'Ngày tạo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          task.createdAt.toLocal().toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      if (task.attachments != null && task.attachments!.isNotEmpty) ...[
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.attach_file, color: Colors.blue.shade600),
                          title: Text(
                            'Tệp đính kèm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: task.attachments!.map((file) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '📎 $file',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/task-form', arguments: task);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Cập nhật công việc',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final updatedTask = task.copyWith(
                    completed: !task.completed,
                    status: task.completed ? 'To do' : 'Done',
                    updatedAt: DateTime.now(),
                  );
                  await TaskService.updateTask(updatedTask);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.completed ? Colors.orange.shade600 : Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  task.completed
                      ? 'Chưa hoàn thành'
                      : 'Xác nhận hoàn thành',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Xóa công việc
                  await TaskService.deleteTask(task.id!);
                  // Hiển thị thông báo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Xóa công việc Thành Công'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  // Quay lại TaskListScreen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Xóa công việc',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
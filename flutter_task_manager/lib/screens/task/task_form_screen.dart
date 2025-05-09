import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  int priority = 2;
  String status = 'To do';
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      final task = widget.task!;
      title = task.title;
      description = task.description;
      priority = task.priority;
      status = task.status;
      dueDate = task.dueDate;
    } else {
      title = '';
      description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Thêm công việc' : 'Sửa công việc',
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
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.task == null ? 'Tạo công việc mới' : 'Chỉnh sửa công việc',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Điền thông tin chi tiết',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: title,
                          decoration: InputDecoration(
                            labelText: 'Tiêu đề',
                            prefixIcon: Icon(Icons.title, color: Colors.blue.shade600),
                            labelStyle: const TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          validator: (val) => val!.isEmpty ? 'Không được để trống' : null,
                          onSaved: (val) => title = val!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: description,
                          decoration: InputDecoration(
                            labelText: 'Mô tả',
                            prefixIcon: Icon(Icons.description, color: Colors.blue.shade600),
                            labelStyle: const TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          maxLines: 3,
                          onSaved: (val) => description = val!,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: priority,
                          decoration: InputDecoration(
                            labelText: 'Độ ưu tiên',
                            prefixIcon: Icon(Icons.priority_high, color: Colors.blue.shade600),
                            labelStyle: const TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Thấp')),
                            DropdownMenuItem(value: 2, child: Text('Trung bình')),
                            DropdownMenuItem(value: 3, child: Text('Cao')),
                          ],
                          onChanged: (val) => setState(() => priority = val!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: status,
                          decoration: InputDecoration(
                            labelText: 'Trạng thái',
                            prefixIcon: Icon(Icons.info, color: Colors.blue.shade600),
                            labelStyle: const TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          items: ['To do', 'In progress', 'Done', 'Cancelled']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (val) => setState(() => status = val!),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.date_range, color: Colors.blue.shade600),
                          title: Text(
                            dueDate != null
                                ? 'Hạn: ${dueDate!.toLocal().toString().split(' ')[0]}'
                                : 'Chọn hạn hoàn thành',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => dueDate = picked);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final task = TaskModel(
                      id: widget.task?.id ?? const Uuid().v4(),
                      title: title,
                      description: description,
                      status: status,
                      priority: priority,
                      dueDate: dueDate,
                      createdAt: widget.task?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                      assignedTo: null,
                      createdBy: 'hung',
                      category: null,
                      attachments: null,
                      completed: widget.task?.completed ?? false,
                    );

                    if (widget.task == null) {
                      await TaskService.insertTask(task);
                    } else {
                      await TaskService.updateTask(task);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu công việc')),
                    );

                    Navigator.pop(context);
                  }
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
                  'Lưu công việc',
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
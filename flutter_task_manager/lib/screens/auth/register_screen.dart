import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_task_manager/data/user_dao.dart';
import 'package:flutter_task_manager/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  final UserDao _userDao = UserDao();

  Future<bool> _checkUsernameExists(String username) async {
    final user = await _userDao.getUserByUsername(username);
    return user != null;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Kiểm tra xem tên người dùng đã tồn tại chưa
      final usernameExists = await _checkUsernameExists(username);
      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tên đăng nhập đã tồn tại!')),
        );
        return;
      }

      // Tạo người dùng mới
      final newUser = UserModel(
        id: const Uuid().v4(),
        username: username,
        email: email,
        password: password, // Lưu ý: Trong thực tế, nên mã hóa mật khẩu
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      // Lưu vào cơ sở dữ liệu
      await _userDao.insertUser(newUser);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );

      // Quay lại màn hình đăng nhập
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký tài khoản',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.person_add,
                size: 100,
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 20),
              Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Đăng ký để bắt đầu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 30),
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
                          decoration: InputDecoration(
                            labelText: 'Tên đăng nhập',
                            prefixIcon: Icon(Icons.person, color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Không được để trống';
                            }
                            return null;
                          },
                          onSaved: (value) => username = value!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email, color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                          onSaved: (value) => email = value!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon: Icon(Icons.lock, color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue.shade600),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Không được để trống';
                            }
                            if (value.length < 6) {
                              return 'Tối thiểu 6 ký tự';
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
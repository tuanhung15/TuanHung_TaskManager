import 'package:flutter/material.dart';
import 'package:flutter_task_manager/data/user_dao.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  final UserDao _userDao = UserDao();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Kiểm tra thông tin đăng nhập từ cơ sở dữ liệu
      final user = await _userDao.getUserByUsername(username);
      if (user != null && user.password == password) {
        // Đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
        Navigator.pushReplacementNamed(context, '/task-list');
      } else {
        // Đăng nhập thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tên đăng nhập hoặc mật khẩu sai!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Đăng nhập',
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
                Icons.lock_outline,
                size: 100,
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 20),
              Text(
                'Chào mừng bạn!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Đăng nhập để tiếp tục',
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
                onPressed: _login,
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
                  'Đăng nhập',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Đăng ký Tài Khoản',
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
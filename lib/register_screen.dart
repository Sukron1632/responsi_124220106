import 'package:flutter/material.dart';
import 'package:responsi/user_model.dart';
import '../services/hive_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Cek apakah username sudah ada
      if (HiveService.isUsernameTaken(_usernameController.text)) {
        _showErrorDialog('Username sudah terdaftar');
        return;
      }

      // Cek apakah password cocok
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorDialog('Password tidak cocok');
        return;
      }

      // Buat user baru
      final newUser = User(
        username: _usernameController.text,
        password: _passwordController.text
      );

      // Simpan user
      HiveService.saveUser(newUser).then((_) {
        // Navigasi ke layar login setelah registrasi berhasil
        Navigator.pushReplacementNamed(context, '/login');
        
        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil!')),
        );
      }).catchError((error) {
        _showErrorDialog('Gagal menyimpan user: $error');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Username TextField
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan username';
                  }
                  if (value.length < 3) {
                    return 'Username minimal 3 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password TextField
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible 
                        ? Icons.visibility 
                        : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Konfirmasi Password TextField
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password';
                  }
                  if (value != _passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              SizedBox( height: 16),

              // Tombol Registrasi
              ElevatedButton(
                onPressed: _register,
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
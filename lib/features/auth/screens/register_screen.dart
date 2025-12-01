import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../models/register_form.dart';
import '../models/login_form.dart';

/// Registration screen for new user signup.
/// 
/// Provides form for name, email, password, and password confirmation.
/// Connected to AuthCubit for backend integration.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  // Formz inputs
  Name _name = const Name.pure();
  Email _email = const Email.pure();
  Password _password = const Password.pure();
  PasswordConfirmation _passwordConfirmation = const PasswordConfirmation.pure();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _nameChanged(String value) {
    setState(() {
      _name = Name.dirty(value);
    });
  }

  void _emailChanged(String value) {
    setState(() {
      _email = Email.dirty(value);
    });
  }

  void _passwordChanged(String value) {
    setState(() {
      _password = Password.dirty(value);
      // Update password confirmation when password changes
      _passwordConfirmation = PasswordConfirmation.dirty(
        password: value,
        value: _passwordConfirmationController.text,
      );
    });
  }

  void _passwordConfirmationChanged(String value) {
    setState(() {
      _passwordConfirmation = PasswordConfirmation.dirty(
        password: _passwordController.text,
        value: value,
      );
    });
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            name: _name.value,
            email: _email.value,
            password: _password.value,
            passwordConfirmation: _passwordConfirmation.value,
          );
    }
  }

  String? _getNameError() {
    if (_name.isPure) return null;
    switch (_name.error) {
      case NameValidationError.empty:
        return 'Please enter your name';
      case NameValidationError.tooShort:
        return 'Name must be at least 2 characters';
      default:
        return null;
    }
  }

  String? _getEmailError() {
    if (_email.isPure) return null;
    switch (_email.error) {
      case EmailValidationError.empty:
        return 'Please enter your email';
      case EmailValidationError.invalid:
        return 'Please enter a valid email';
      default:
        return null;
    }
  }

  String? _getPasswordError() {
    if (_password.isPure) return null;
    switch (_password.error) {
      case PasswordValidationError.empty:
        return 'Please enter a password';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters';
      default:
        return null;
    }
  }

  String? _getPasswordConfirmationError() {
    if (_passwordConfirmation.isPure) return null;
    switch (_passwordConfirmation.error) {
      case PasswordConfirmationValidationError.mismatch:
        return 'Passwords do not match';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Pop all routes - BlocBuilder in main.dart will automatically show main app
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Headline
                    Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      'Enter your details below to create your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      onChanged: _nameChanged,
                      decoration: InputDecoration(
                        labelText: 'Full name',
                        errorText: _getNameError(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                      ),
                      validator: (value) => _getNameError(),
                    ),
                    const SizedBox(height: 24),
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _emailChanged,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _getEmailError(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                      ),
                      validator: (value) => _getEmailError(),
                    ),
                    const SizedBox(height: 24),
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: _passwordChanged,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _getPasswordError(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) => _getPasswordError(),
                    ),
                    const SizedBox(height: 24),
                    // Password confirmation field
                    TextFormField(
                      controller: _passwordConfirmationController,
                      obscureText: _obscurePasswordConfirmation,
                      onChanged: _passwordConfirmationChanged,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        errorText: _getPasswordConfirmationError(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordConfirmation
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordConfirmation =
                                  !_obscurePasswordConfirmation;
                            });
                          },
                        ),
                      ),
                      validator: (value) => _getPasswordConfirmationError(),
                    ),
                    const SizedBox(height: 32),
                    // Create account button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (isLoading || !Formz.validate([_name, _email, _password, _passwordConfirmation])) 
                            ? null 
                            : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.metricPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.gray400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Create account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


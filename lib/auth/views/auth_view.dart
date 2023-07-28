import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_bloc.dart';
import 'package:revise_notes/auth/bloc/auth_event.dart';

class AuthView extends StatefulWidget {
  final bool loggingIn;
  const AuthView({
    super.key,
    required this.loggingIn,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loggingIn = widget.loggingIn;
    return Scaffold(
      appBar: AppBar(
        title: loggingIn ? const Text('Log In') : const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address.';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password.';
                } else if (value.length < 6) {
                  return 'Please enter at least 6 characters.';
                } else {
                  return null;
                }
              },
            ),
            TextButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;
                loggingIn
                    ? context.read<AuthBloc>().add(
                          AuthEventLogIn(
                            email: email,
                            password: password,
                          ),
                        )
                    : context.read<AuthBloc>().add(
                          AuthEventSignUp(
                            email: email,
                            password: password,
                          ),
                        );
              },
              child: Text(loggingIn ? 'Log In' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () => loggingIn
                  ? context.read<AuthBloc>().add(
                        const AuthEventSigningUp(),
                      )
                  : context.read<AuthBloc>().add(
                        const AuthEventLoggingIn(),
                      ),
              child: Text(loggingIn
                  ? 'Not Logged In? Sign Up Now!'
                  : 'Already Logged In? Log In Here!'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:carpooling_frontend/screens/driver_information_screen/driver_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_bloc.dart';
import 'signup_state.dart';
import 'signup_event.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SignupBloc(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          body: BlocConsumer<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signup Successful!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate based on role
                if (state.role == "Жолооч") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverInformationScreen(),
                    ),
                  );
                } else {
                  // Navigate back to the home screen or parent flow
                  Navigator.pop(context);
                }
              }

              if (state.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Text(
                          "Carpooling",
                          style: TextStyle(
                              fontSize: 48, color: theme.colorScheme.surface),
                        ),
                        const SizedBox(height: 84),

                        // Tab Bar
                        TabBar(
                          labelColor: theme.colorScheme.surface,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: theme.colorScheme.surface,
                          onTap: (index) {
                            final role = index == 0 ? "Эцэг эх" : "Жолооч";
                            context
                                .read<SignupBloc>()
                                .add(SignupRoleChanged(role));
                          },
                          tabs: const [
                            Tab(text: "Эцэг эх"),
                            Tab(text: "Жолооч"),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tab Bar Views
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: TabBarView(
                            children: [
                              _buildSignupForm(context, "Эцэг эх"),
                              _buildSignupForm(context, "Жолооч"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, String role) {
    final theme = Theme.of(context);
    final bloc = context.read<SignupBloc>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email or Phone Field
          TextField(
            onChanged: (value) => bloc.add(SignupEmailChanged(value)),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Имэйл',
              labelStyle: theme.textTheme.bodyLarge,
              fillColor: null,
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // First Name Field
          TextField(
            onChanged: (value) => bloc.add(SignupFirstNameChanged(value)),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Овог',
              labelStyle: theme.textTheme.bodyLarge,
              fillColor: null,
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Last Name Field
          TextField(
            onChanged: (value) => bloc.add(SignupLastNameChanged(value)),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Нэр',
              labelStyle: theme.textTheme.bodyLarge,
              fillColor: null,
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Phone Number Field
          TextField(
            onChanged: (value) => bloc.add(SignupPhoneNumberChanged(value)),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Утасны дугаар',
              labelStyle: theme.textTheme.bodyLarge,
              fillColor: null,
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Username Field
          TextField(
            onChanged: (value) => bloc.add(SignupUsernameChanged(value)),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Нэвтрэх нэр',
              labelStyle: theme.textTheme.bodyLarge,
              fillColor: null,
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password Field
          BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) {
              return TextField(
                obscureText: state.obscurePassword,
                onChanged: (value) => bloc.add(SignupPasswordChanged(value)),
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Нууц үг',
                  labelStyle: theme.textTheme.bodyLarge,
                  fillColor: null,
                  filled: false,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      bloc.add(TogglePasswordVisibility());
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) {
              return TextField(
                obscureText: state.obscureConfirmPassword,
                onChanged: (value) =>
                    bloc.add(SignupPasswordAgainChanged(value)),
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Нууц үг давтах',
                  labelStyle: theme.textTheme.bodyLarge,
                  fillColor: null,
                  filled: false,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      bloc.add(ToggleConfirmPasswordVisibility());
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                bloc.add(SignupSubmitted(role: role));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Бүртгүүлэх',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

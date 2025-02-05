import 'package:flutter/material.dart';
import 'package:qrcode/routes/router.dart';
import '../bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passwordC =
      TextEditingController(text: "admin123");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SCAN-KI APP"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: emailC,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: passwordC,
            obscureText: true,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // proses login
              context
                  .read<AuthBloc>()
                  .add(AuthEventLogin(emailC.text, passwordC.text));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 25),
              // backgroundColor: Color.fromARGB(255, 0, 38, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthStateLogin) {
                  context.goNamed(Routes.home);
                }
                if (state is AuthStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 2),
                  ));
                }
              },
              builder: (context, state) {
                if (state is AuthStateLoading) {
                  return const Text("LOADING ...");
                }
                return const Text("LOGIN");
              },
            ),
          ),
        ],
      ),
    );
  }
}

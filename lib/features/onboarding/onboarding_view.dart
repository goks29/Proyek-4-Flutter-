import 'package:flutter/material.dart';
import 'package:logbook_app_001/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int step = 1;
  List<Map<String,String>> onBoardingView = [
    {'gambar': 'assets/images/1.jpeg', 'judul': '1', 'deskripsi': 'Aku Sayang Ibu.'},
    { 'gambar': 'assets/images/2.png', 'judul': '2', 'deskripsi': 'Juga Sayang Ayah' },
    { 'gambar': 'assets/images/3.jpeg', 'judul': '3', 'deskripsi': 'Sayang Semuanya.' },
  ];

  void _handleNext() {
    if (step < onBoardingView.length) {
      setState(() {
        step++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Halaman OnBoarding"),
            const SizedBox(height: 20),

            Image.asset(
              onBoardingView[step - 1]['gambar']!,
              height: 250,
            ),
            Text(
              onBoardingView[step - 1]['judul']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              onBoardingView[step - 1]['deskripsi']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey)
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 5),
                    height: 10,
                    width: (index == step - 1) ? 20 : 10,
                    decoration: BoxDecoration(
                      color: (index == step - 1) ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5) 
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: _handleNext,
              child: const Text("Lanjut"),
            ),
          ],
        ),
      ),
    );
  }
}
  import 'package:flutter/material.dart';
  import 'counter_controller.dart';

  class CounterView extends StatefulWidget {
      const CounterView({super.key});
      @override
      State<CounterView> createState() => _CounterViewState();
  }

  class _CounterViewState extends State<CounterView> {
      final CounterController _controller = CounterController();
      final TextEditingController _stepInputController = TextEditingController();

      void _showResetDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Konfirmasi Reset"),
              content: const Text("Apakah anda yakin ingin reset?"),
              actions: [
                //Tombol Batal
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                //Tombol Ya
                TextButton(
                  onPressed: () {
                    setState(() => _controller.reset()); 
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Data Berhasil direset!"),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text("Ya", style: TextStyle(color: Colors.red)),
                )
              ],
            );
          }
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("LogBook: Versi SRP"),
            centerTitle: true, 
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Total Hitungan:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${_controller.value}',
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Tombol 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol Tambah
                    ElevatedButton(
                      onPressed: () => setState(() => _controller.increment()),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 15),

                    // Tombol Kurang
                    ElevatedButton(
                      onPressed: () => setState(() => _controller.decrement()),
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 15),

                    // Tombol Reset
                    ElevatedButton(
                      onPressed: _showResetDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red,
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Input Nilai Step
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _stepInputController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Masukkan Nilai Step",
                      hintText: "Contoh: 5",
                      prefixIcon: Icon(Icons.bolt),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue != null) {
                        setState(() {
                          _controller.updateStep(parsedValue);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),

                const Divider(thickness: 2),
                const SizedBox(height: 10),
                const Text(
                  "5 Aktivitas Terakhir:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                // List Riwayat 
                Column(
                  children: _controller.history.map((log) {
                    Color warnaLog = log.contains("Ditambah")
                        ? Colors.green
                        : log.contains("Dikurang")
                            ? Colors.red
                            : Colors.grey;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Icon(Icons.history, color: warnaLog),
                        title: Text(
                          log,
                          style: TextStyle(
                            color: warnaLog,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }
  }
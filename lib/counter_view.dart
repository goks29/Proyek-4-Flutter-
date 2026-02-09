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

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("LogBook: Versi SRP")),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Total Hitungan:"),
                Text('${_controller.value}', style: const TextStyle(fontSize: 40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Tombol Tambah
                      ElevatedButton(
                        onPressed: () => setState(() => _controller.increment()),
                        child: const Icon(Icons.add),
                      ), 
                      const SizedBox(width: 20),

                      //Tombol Kurang
                      ElevatedButton(
                        onPressed: () => setState(() => _controller.decrement()),
                        child: const Icon(Icons.remove),
                      ), 
                      const SizedBox(width: 20),

                      //Tombol Reset
                      ElevatedButton(
                        onPressed: () => setState(() => _controller.reset()),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
                        child: const Icon(Icons.refresh)
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: TextField(
                      controller: _stepInputController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Masukan Nilai Step",
                        border: OutlineInputBorder()
                      ),
                      onChanged: (value) {
                        int? parsedValue = int.tryParse(value);
                        if (parsedValue != null) {
                          setState(() {
                            _controller.updateStep(parsedValue);
                          });
                        }
                      },
                  )
                ),

                const Divider(),
                const Text("5 Aktivitas Terakhir:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Column(
                  children: _controller.history.map((log) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(log, style: const TextStyle(fontSize: 14)),
                      ),
                    );
                  }).toList(),
                )
              ],
          ),
        ),
      );
    }
}
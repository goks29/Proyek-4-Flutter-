import 'package:shared_preferences/shared_preferences.dart';

class CounterController {
    int _counter = 0; // Variabel private (Enkapsulasi)
    int _step = 1;
    List<String> _history = [];

    int get value => _counter; // Getter untuk akses data
    int get stepValue => _step;
    List<String> get history => _history;

    final String username;

    CounterController({
      required this.username,
    });

    void increment() {
      _counter += _step;
      _addLog("menambah $_step");
      saveData();
    } 
    
    void decrement() { 
      if (_counter > 0) {
        _counter -= _step; 
        if (_counter < 0) {
          _counter = 0;
        }
        _addLog("mengurang $_step");
        saveData();
      }
    }

    void reset() {
      _counter = 0;
      _addLog("mereset ke 0");
      saveData();
    } 

    void updateStep(int newStep) {
      _step = newStep;
      saveData();
    }

    void _addLog(String action) {
      String time = DateTime.now().toString().split('.')[0];
      _history.insert(0, "${username} $action pada $time");
      
      if (_history.length > 5) {
        _history.removeLast();
      }
    }

    Future<void> saveData() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt('${username}last_counter', _counter);
      await prefs.setInt('${username}last_step', _step);
      await prefs.setStringList('${username}last_history', _history);
    }

    Future<void> readData() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      int? lastCounter = prefs.getInt('${username}last_counter');
      int? lastStep = prefs.getInt('${username}last_step');
      List<String>? lastHistory = prefs.getStringList('${username}last_history');

      _counter = lastCounter ?? 0;
      _step = lastStep ?? 1;
      _history = lastHistory ?? [];
    }

    String ucapan (int jam) {
      if (jam <= 11 && jam >= 6) {
        return "Selamat Pagi";
      } else if (jam <= 14 && jam >= 12 ) {
        return "Selamat Siang";
      } else if (jam <= 18 && jam >= 15 ) {
        return "Selamat Sore";
      } else {
        return "Selamat Malam";
      }
  }

}
class CounterController {
    int _counter = 0; // Variabel private (Enkapsulasi)
    int _step = 1;
    final List<String> _history = [];

    int get value => _counter; // Getter untuk akses data
    int get stepValue => _step;
    List<String> get history => _history;

    void increment() {
      _counter += _step;
      _addLog("Ditambah $_step");
    } 
    
    void decrement() { 
      if (_counter > 0) {
        _counter -= _step; 
        _addLog("Dikurang $_step");
      }
    }

    void reset() {
      _counter = 0;
      _addLog("Direset ke 0");
    } 

    void updateStep(int newStep) {
      _step = newStep;
    }

    void _addLog(String action) {
      String time = DateTime.now().toString().split('.')[0];
      _history.insert(0, "$action pada $time");
      
      if (_history.length > 5) {
        _history.removeLast();
      }
    }
}
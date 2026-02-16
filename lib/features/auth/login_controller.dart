class LoginController {
  final Map<String, String> _account = {
    'admin': '123',
    'king': '123',
    'ayam': '123',
  };

  bool login(String username, String password) {
    if (_account.containsKey(username)) {
      String correctPassword = _account[username]!;

      if (correctPassword == password) {
        return true;
      }
    } 
    return false;
  }
}
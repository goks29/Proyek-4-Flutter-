

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logbook_app_001/features/auth/login_controller.dart';

void main() {
  var actual, expected;

  group('Module 2 - LoginController (with storage & step)', () {
    late LoginController controller;
    const username = "admin";
    const password = "123";
    const password_salah = "111";

    setUp(() async {
      // (1) setup (arrange, build)
      SharedPreferences.setMockInitialValues({}); // mock storage
      controller = LoginController();
      await controller.login(username, password); // load initial value
    });

    test('login berhasil', () {
      // (2) exercise set up data
      actual = controller.login(username, password);
      expected = true;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual');
    });

    test('login gagal', () {
      actual = controller.login(username, password_salah);
      expected = false;

      expect(actual, expected, reason: 'Expected  $expected but got $actual');
    });

    test('role sesuai', (){
      actual = controller.getRole(username);
      expected = 'Ketua';

      expect(actual, expected, reason: 'Expected $expected but got $actual');
    });
  });
}


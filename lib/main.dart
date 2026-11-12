import 'core/vector.dart';

void main() {
  final v1 = Vector(1, "1/2", "-0.75");
  final v2 = Vector([2, "3/4", "1,25"]);
  final Vector v4 = Vector([3, 5, 9]);

  print("ТЕСТ 1: Успешное сложение");
  final solOk = v1.add(v2);
  print(solOk);

  print("ТЕСТ 2: Попытка сложить векторы разной длины (проверка ошибки)");
  final v3 = Vector(5, 10);
  final solFail = v1.add(v3);
  print(solFail);

  print("ТЕСТ 3: Тест цепочки");
  final result = v1 + v1 + v1 + v1 + v4;
  print(result);
}

import "core/vector.dart";
import "core/fraction.dart";
import "core/vector_steps.dart" as step;

void main() {
  final a = Vector(1, "1/2", "-3/4");
  final b = Vector(2, -1, 4);
  final c = Vector(0, 3, "5/2");

  final fast = a + b * 2 - c;
  print("Быстрый расчёт: $fast\n");

  print("ТЕСТ 2. Сложение");
  print(step.add(a, b));

  print("\nТЕСТ 3. Смешанное произведение");
  print(step.mixed(a, b, c));

  print("\nТЕСТ 4. Остаток от деления у Fraction");
  final first = Fraction(9, 7);
  final second = Fraction(1);

  print(first % second);
  print(first.toDouble());
  print(first.floor());
  print(first.ceil());
  print(Fraction(4).ceil());
}

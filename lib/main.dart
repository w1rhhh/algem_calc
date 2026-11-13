import "core/vector.dart";
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
}

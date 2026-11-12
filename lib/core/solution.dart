import "exception.dart";

class Solution<T> {
  final String head; // заголовок
  final String description; // описание
  final T? value; // ответ
  final String latex; // формула LaTeX
  final List<Solution<Object?>> steps; // дерево решений
  final CalcException? error; // ошибки

  Solution._({
    required this.head,
    required this.description,
    this.value,
    required this.latex,
    List<Solution<Object?>> steps = const [],
    this.error,
  }) : steps = List.unmodifiable(steps);

  factory Solution.success({
    required String head,
    required String description,
    required T value,
    required String latex,
    List<Solution<Object?>> steps = const [],
  }) {
    return Solution._(
      head: head,
      description: description,
      value: value,
      latex: latex,
      steps: steps,
    );
  }

  factory Solution.failed({
    required String head,
    String? description,
    String? latex,
    List<Solution<Object?>> steps = const [],
    required CalcException error,
  }) {
    return Solution._(
      head: head,
      description: description ?? error.message,
      latex: latex ?? "\\text{${error.message}}",
      steps: steps,
      error: error,
    );
  }

  // геттеры состояния
  bool get isFail => (error != null);
  bool get isSuccess => (error == null) && (value != null);
  bool get hasSteps => steps.isNotEmpty;

  // геттер ответа
  T get ans {
    if (isFail) throw error!;
    return value as T;
  }

  @override
  String toString([int depth = 0]) {
    final buffer = StringBuffer();
    final currStep = "  " * depth;

    buffer.writeln("$currStep- $head ($description)");
    buffer.writeln("$currStep  Формула LaTeX: $latex");

    if (hasSteps) {
      buffer.writeln("$currStep  [Подробно...]");
      for (var i = 0; i < steps.length; ++i) {
        buffer.write(steps[i].toString(depth + 1));
      }
    }

    if (depth == 0) {
      buffer.writeln(
        isFail ? "[ИТОГ] ${error!.message}" : "[ОТВЕТ] $value (LaTeX: $latex)",
      );
    }

    return buffer.toString();
  }
}

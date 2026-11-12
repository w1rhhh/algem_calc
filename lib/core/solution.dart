import "exception.dart";

class CalcStep {
  final String head;
  final String description;
  final String latex;

  const CalcStep({
    required this.head,
    this.description = "",
    required this.latex,
  });

  @override
  String toString() =>
      description.isEmpty ? "$head\n$latex" : "$head ($description)\n$latex";
}

class Solution<T> {
  final T? value;
  final String finalLatex;
  final List<CalcStep> steps;
  final CalcException? error;

  const Solution._({
    this.value,
    required this.finalLatex,
    required this.steps,
    this.error,
  });

  // конструктор в случае успеха
  factory Solution.success({
    required T value,
    required String finalLatex,
    required List<CalcStep> steps,
  }) {
    return Solution._(
      value: value,
      finalLatex: finalLatex,
      steps: List.unmodifiable(steps),
    );
  }

  // конструктор в случае ошибки
  factory Solution.fail({
    required List<CalcStep> steps,
    required CalcException error,
    String? finalLatex,
  }) {
    return Solution._(
      finalLatex: finalLatex ?? "\\text{${error.message}}",
      steps: List.unmodifiable(steps),
      error: error,
    );
  }

  // полезные геттеры
  bool get isSuccess => (value != null) && (error == null);
  bool get isFail => (error != null);

  // перегрузка консольного вывода
  @override
  String toString() {
    final buffer = StringBuffer();

    for (var i = 0; i < steps.length; ++i) {
      buffer.write("[Решение] Шаг ${i + 1}. ");
      buffer.writeln(steps[i]);
    }

    buffer.writeln(
      isFail
          ? "${error!.message}"
          : "[Ответ] $value (LaTeX формат: $finalLatex)",
    );

    return buffer.toString();
  }
}

import "solution.dart";
import "exception.dart";
import "fraction.dart";

class Vector {
  final List<Fraction> coords;

  Vector._(List<Fraction> elements) : coords = List.unmodifiable(elements);

  static Fraction _toFraction(Object value) {
    return switch (value) {
      Fraction f => f,
      int i => Fraction(i),
      BigInt b => Fraction(b),
      String s => Fraction.parse(s),
      _ => throw CalcException.invalidFormat(
        "[Ошибка] Координата вектора не может быть типа ${value.runtimeType}.",
      ),
    };
  }

  factory Vector(Object a, [Object? b, Object? c, Object? d]) {
    if (a is Iterable) {
      if (b != null || c != null || d != null) {
        throw CalcException.invalidFormat(
          "[Ошибка] Передайте либо один список, либо координаты через запятую.",
        );
      }

      final list = a.map((e) => _toFraction(e as Object)).toList();

      if (list.isEmpty) {
        throw CalcException.dimension("[Ошибка] Вектор не может быть пустым.");
      }

      return Vector._(list);
    }

    if (b == null) {
      throw CalcException.dimension("[Ошибка] Вектор не может быть одномерным");
    }

    return Vector._([
      _toFraction(a),
      _toFraction(b),
      if (c != null) _toFraction(c),
      if (d != null) _toFraction(d),
    ]);
  }

  // геттеры
  int get size => coords.length;
  bool get isZero => coords.every((e) => e.isZero);

  // обращение по индексу
  Fraction operator [](int index) {
    if (index < 0 || index >= size) {
      throw CalcException.dimension("[Ошибка] Выход за границы вектора.");
    }

    return coords[index];
  }

  // красивый вывод в LaTeX
  static String _wrap(Fraction f) =>
      f < Fraction(0) ? "\\left(${f.toLatex()}\\right)" : f.toLatex();

  // -=- Новые векторные операторы -=-

  Solution<Vector> add(
    Object other, [
    bool isSubtract = false,
    Solution<Vector>? leftSol,
  ]) {
    final sign = isSubtract ? "-" : "+";
    final head = isSubtract ? "Вычитание векторов" : "Сложение векторов";

    final Vector rightVec;
    Solution<Vector>? rightSol;

    // проверка на тип
    if (other is Vector) {
      rightVec = other;
    } else if (other is Solution<Vector>) {
      if (other.isFail) return other;
      rightVec = other.ans;
      rightSol = other;
    } else {
      return Solution.failed(
        head: head,
        description: "Проверка типа второго операнда",
        error: CalcException.invalidFormat(
          "[Ошибка] Ожидался Vector или Solution<Vector>, получено: ${other.runtimeType}.",
        ),
      );
    }

    if (size != rightVec.size) {
      return Solution.failed(
        head: head,
        description: "Проверка размерности векторов",
        steps: [if (leftSol != null) leftSol, if (rightSol != null) rightSol],
        error: CalcException.dimension(
          "[Ошибка] Нельзя работать с векторами разной длины ($size и ${rightVec.size}).",
        ),
      );
    }

    final newCoords = <Fraction>[];
    final steps = <Solution<Object?>>[
      if (leftSol != null) leftSol,
      if (rightSol != null) rightSol,
    ];
    final latexRows = <String>[];

    for (var i = 0; i < size; ++i) {
      final a = coords[i];
      final b = rightVec.coords[i];
      final res = isSubtract ? (a - b) : (a + b);

      newCoords.add(res);

      final latex = "${a.toLatex()} $sign ${_wrap(b)}";
      latexRows.add(latex);

      steps.add(
        Solution.success(
          head: "Координата №${i + 1}",
          description: isSubtract
              ? "Вычитаем ${i + 1}-ю координату второго вектора из первого"
              : "Складываем ${i + 1}-е координаты обоих векторов",
          value: res,
          latex: "$latex = ${res.toLatex()}",
        ),
      );
    }

    final answer = Vector._(newCoords);

    final midMatrixLatex =
        "\\begin{pmatrix} ${latexRows.join(" \\\\ ")} \\end{pmatrix}";

    return Solution.success(
      head: head,
      description:
          "Покоординатное выполнение операции для векторов размерности $size",
      value: answer,
      latex:
          "${toLatex()} $sign ${rightVec.toLatex()} = $midMatrixLatex = ${answer.toLatex()}",
      steps: steps,
    );
  }

  Solution<Vector> operator +(Object other) => add(other, false);
  Solution<Vector> operator -(Object other) => add(other, true);

  @override
  String toString() => "(${coords.join(", ")})";

  String toLatex({bool asColumn = true}) {
    final sep = asColumn ? " \\\\ " : " & ";
    return "\\begin{pmatrix} ${coords.map((e) => e.toLatex()).join(sep)} \\end{pmatrix}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vector || size != other.size) return false;

    for (var i = 0; i < size; ++i) {
      if (coords[i] != other.coords[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(coords);
}

extension VectorSolutionOps on Solution<Vector> {
  Solution<Vector> operator +(Object other) =>
      isFail ? this : ans.add(other, false, this);

  Solution<Vector> operator -(Object other) =>
      isFail ? this : ans.add(other, true, this);
}

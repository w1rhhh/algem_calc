import "exception.dart";
import "fraction.dart";

class Vector {
  final List<Fraction> coords;

  Vector._(List<Fraction> elements) : coords = List.unmodifiable(elements);

  // всеядный фабричный конструктор
  factory Vector(Object a, [Object? b, Object? c, Object? d]) {
    if (a is Iterable) {
      if (b != null || c != null || d != null) {
        throw CalcException.invalidFormat(
          "[Ошибка] Передайте либо один список, либо координаты через запятую.",
        );
      }

      final list = a.map((e) => toFraction(e as Object)).toList();

      if (list.isEmpty) {
        throw CalcException.dimension("[Ошибка] Вектор не может быть пустым.");
      }

      if (list.length < 2) {
        throw CalcException.dimension(
          "[Ошибка] Вектор должен содержать минимум 2 координаты.",
        );
      }

      return Vector._(list);
    }

    if (b == null) {
      throw CalcException.dimension("[Ошибка] Вектор не может быть одномерным");
    }

    return Vector._([
      toFraction(a),
      toFraction(b),
      if (c != null) toFraction(c),
      if (d != null) toFraction(d),
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

  // -=- Новые векторные операторы -=-

  Vector operator +(Vector other) {
    if (size != other.size) {
      throw CalcException.dimension(
        "[Ошибка] Размерность векторов не совпадает.",
      );
    }

    return Vector._(List.generate(size, (i) => this[i] + other[i]));
  }

  Vector operator -(Vector other) {
    if (size != other.size) {
      throw CalcException.dimension(
        "[Ошибка] Размерность векторов не совпадает.",
      );
    }

    return Vector._(List.generate(size, (i) => this[i] - other[i]));
  }

  Vector operator -() => Vector._(coords.map((e) => -e).toList());

  Vector operator *(Object scalar) {
    final factor = toFraction(scalar);
    return Vector._(coords.map((e) => e * factor).toList());
  }

  @override
  int get hashCode => Object.hashAll(coords);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vector &&
          size == other.size &&
          List.generate(size, (i) => i).every((i) => this[i] == other[i]));

  @override
  String toString() => "(${coords.join(", ")})";

  String toLatex({bool asColumn = true}) {
    final sep = asColumn ? " \\\\ " : " & ";
    return "\\begin{pmatrix} ${coords.map((e) => e.toLatex()).join(sep)} \\end{pmatrix}";
  }
}

Fraction dot(Vector a, Vector b) {
  if (a.size != b.size) {
    throw CalcException.dimension(
      "[Ошибка] Размерность векторов не совпадает.",
    );
  }

  Fraction answer = Fraction(0);

  for (var i = 0; i < a.size; ++i) {
    answer += a[i] * b[i];
  }

  return answer;
}

// глобальные функции работы с векторами
Vector cross(Vector a, Vector b) {
  if (a.size != 3 || b.size != 3) {
    throw CalcException.dimension(
      "[Ошибка] Векторное произведение определено только в трехмерном пространстве.",
    );
  }

  return Vector._([
    a[1] * b[2] - a[2] * b[1],
    a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0],
  ]);
}

Fraction mixed(Vector a, Vector b, Vector c) => dot(cross(a, b), c);

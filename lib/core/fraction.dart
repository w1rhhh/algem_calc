import "exception.dart";

final _zero = BigInt.zero;
final _one = BigInt.one;

class Fraction implements Comparable<Fraction> {
  final BigInt numerator;
  final BigInt denominator;

  // динамическая типизация числового типа
  static BigInt _toBigInt(Object value) {
    return switch (value) {
      BigInt b => b,
      int i => BigInt.from(i),
      _ => throw CalcException.invalidFormat(
        "[Ошибка] Получено значение отличного типа от int и BigInt (${value.runtimeType}).",
      ),
    };
  }

  // исключить системные ошибки при парсинге, заменить их на самописные
  static BigInt _parseBigInt(String text) {
    final res = BigInt.tryParse(text);
    if (res == null) {
      throw CalcException.invalidFormat(
        "[Ошибка] Некорректная запись числа: '$text'.",
      );
    }

    return res;
  }

  // инициализация объекта
  Fraction._(this.numerator, this.denominator);

  static BigInt _gcd(BigInt a, BigInt b) {
    while (b != _zero) {
      final temp = b;

      b = a % b;
      a = temp;
    }

    return a;
  }

  // фабричный конструктор
  factory Fraction(Object num, [Object? den]) {
    final n = _toBigInt(num);
    final d = _toBigInt(den ?? _one);

    // ловим ошибки
    if (d == _zero) {
      throw CalcException.divisionByZero(
        "[Ошибка] Знаменатель дроби не может равняться нулю.",
      );
    }

    // проверка на ноль
    if (n == _zero) {
      return Fraction._(n, _one);
    }

    final BigInt gcdValue = _gcd(n.abs(), d.abs());

    final sign = (n < _zero) ^ (d < _zero) ? -_one : _one;
    final numerator = sign * (n.abs() ~/ gcdValue);
    final denominator = d.abs() ~/ gcdValue;

    return Fraction._(numerator, denominator);
  }

  // фабричный конструктор для парсинга Fraction из строки
  factory Fraction.parse(String input) {
    final clean = input.trim().replaceAll(",", ".");

    if (clean.isEmpty || clean == "-") {
      return Fraction._(_zero, _one);
    }

    if (clean.contains("/")) {
      final parts = clean.split("/");

      if (parts.length != 2) {
        throw CalcException.invalidFormat("[Ошибка] Дробь введена неверно.");
      }

      return Fraction(
        _parseBigInt(parts[0].trim()),
        _parseBigInt(parts[1].trim()),
      );
    }

    if (clean.contains(".")) {
      final parts = clean.split(".");

      if (parts.length != 2 || parts[1].trim().isEmpty) {
        throw CalcException.invalidFormat("[Ошибка] Дробь введена неверно.");
      }

      final isNegative = clean.startsWith("-");
      final wholeStr = parts[0].replaceAll("-", "").trim();
      final fracStr = parts[1].trim();

      if (fracStr.startsWith("-") || fracStr.startsWith("+")) {
        throw CalcException.invalidFormat("[Ошибка] Дробь введена неверно.");
      }

      final whole = wholeStr.isEmpty ? _zero : _parseBigInt(wholeStr);
      final frac = _parseBigInt(fracStr);

      final scale = BigInt.from(10).pow(fracStr.length);
      final num = whole * scale + frac;

      return Fraction(isNegative ? -num : num, scale);
    }

    return Fraction._(_parseBigInt(clean), _one);
  }

  bool get isZero => numerator == _zero;

  bool get isOne => numerator == _one && denominator == _one;

  Fraction abs() => Fraction._(numerator.abs(), denominator);

  // -=- Перегрузка операторов -=-

  Fraction operator +(Fraction other) {
    return Fraction(
      numerator * other.denominator + denominator * other.numerator,
      denominator * other.denominator,
    );
  }

  Fraction operator -(Fraction other) {
    return Fraction(
      numerator * other.denominator - denominator * other.numerator,
      denominator * other.denominator,
    );
  }

  Fraction operator -() {
    return Fraction._(-numerator, denominator);
  }

  Fraction operator *(Fraction other) {
    return Fraction(
      numerator * other.numerator,
      denominator * other.denominator,
    );
  }

  Fraction operator /(Fraction other) {
    return Fraction(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  BigInt operator ~/(Fraction other) {
    if (other.numerator == _zero) {
      throw CalcException.divisionByZero();
    }

    return (numerator * other.denominator) ~/ (denominator * other.numerator);
  }

  Fraction operator %(Fraction other) {
    if (other.numerator == _zero) {
      throw CalcException.divisionByZero();
    }

    return this - (Fraction(this ~/ other) * other);
  }

  bool operator <(Fraction other) =>
      (numerator * other.denominator) < (other.numerator * denominator);

  bool operator >(Fraction other) =>
      (numerator * other.denominator) > (other.numerator * denominator);

  bool operator <=(Fraction other) =>
      (numerator * other.denominator) <= (other.numerator * denominator);

  bool operator >=(Fraction other) =>
      (numerator * other.denominator) >= (other.numerator * denominator);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Fraction) &&
          (numerator == other.numerator) &&
          (denominator == other.denominator);

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  int compareTo(Fraction other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  // вывод дроби
  @override
  String toString() {
    if (denominator == _one) {
      return "$numerator";
    } else {
      return "$numerator/$denominator";
    }
  }

  // вывод в виде LaTeX
  String toLatex() {
    if (denominator == _one) {
      return "$numerator";
    }

    final sign = numerator < _zero ? "-" : "";
    return "$sign\\frac{${numerator.abs()}}{$denominator}";
  }
}

Fraction toFraction(Object value) {
  return switch (value) {
    Fraction f => f,
    int i => Fraction(i),
    BigInt b => Fraction(b),
    String s => Fraction.parse(s),
    _ => throw CalcException.invalidFormat(
      "[Ошибка] Невозможно привести тип ${value.runtimeType} к типу Fraction.",
    ),
  };
}

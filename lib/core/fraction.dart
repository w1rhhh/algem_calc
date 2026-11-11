final _zero = BigInt.zero;
final _one = BigInt.one;

class Fraction {
  final BigInt numerator;
  final BigInt denominator;

  // динамическая типизация числового типа
  static BigInt _toBigInt(Object value) {
    return switch (value) {
      BigInt b => b,
      int i => BigInt.from(i),
      _ => throw ArgumentError(
        "[Ошибка] Получено значение отличного типа от int и BigInt (${value.runtimeType}).",
      ),
    };
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

  // фабричный конструктор №2
  factory Fraction(Object num, [Object? den]) {
    final n = _toBigInt(num);
    final d = _toBigInt(den ?? _one);

    // ловим ошибки
    if (d == _zero) {
      throw ArgumentError(
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
      throw ArgumentError('[Ошибка] Деление на ноль.');
    }

    return (numerator * other.denominator) ~/ (denominator * other.numerator);
  }

  Fraction operator %(Fraction other) {
    if (other.numerator == _zero) {
      throw ArgumentError('[Ошибка] Деление на ноль.');
    }

    return this - (Fraction(this ~/ other) * other);
  }
}

final _zero = BigInt.zero;
final _one = BigInt.one;

class Fraction {
  final BigInt numerator;
  final BigInt denominator;

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
  factory Fraction.fromBigInt(BigInt num, [BigInt? den]) {
    final d = den ?? _one;

    // ловим ошибки
    if (d == _zero) {
      throw ArgumentError(
        "[Ошибка] Знаменатель дроби не может равняться нулю.",
      );
    }

    // проверка на ноль
    if (num == _zero) {
      return Fraction._(num, _one);
    }

    final BigInt gcdValue = _gcd(num.abs(), d.abs());

    final sign = (num < _zero) ^ (d < _zero) ? -_one : _one;
    final numerator = sign * (num.abs() ~/ gcdValue);
    final denominator = d.abs() ~/ gcdValue;

    return Fraction._(numerator, denominator);
  }

  // фабричный конструктор №1
  factory Fraction(int num, [int den = 1]) {
    return Fraction.fromBigInt(BigInt.from(num), BigInt.from(den));
  }
}

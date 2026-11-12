enum CalcErrorType {
  divisionByZero, // деление на ноль
  invalidFormat, // некорректный ввод строки или типа
  dimensionMismatch, // несовпадение размерностей матриц/векторов
  notSquareMatrix, // матрица не квадратная (для det, A^-1, Крамера)
  singularMatrix, // вырожденная матрица (det = 0)
}

class CalcException implements Exception {
  final CalcErrorType type;
  final String message;

  const CalcException(this.type, this.message);

  factory CalcException.divisionByZero([
    String details = "[Ошибка] Деление на ноль не определено.",
  ]) => CalcException(CalcErrorType.divisionByZero, details);

  factory CalcException.invalidFormat([
    String details = "[Ошибка] Некорректный формат входных данных.",
  ]) => CalcException(CalcErrorType.invalidFormat, details);

  factory CalcException.dimension([
    String details = "[Ошибка] Размерности объектов не подходят для операции.",
  ]) => CalcException(CalcErrorType.dimensionMismatch, details);

  factory CalcException.notSquare([
    String details = "[Ошибка] Операция доступна только для квадратных матриц.",
  ]) => CalcException(CalcErrorType.notSquareMatrix, details);

  factory CalcException.singular([
    String details = "[Ошибка] Матрица вырождена (определитель равен нулю).",
  ]) => CalcException(CalcErrorType.singularMatrix, details);

  @override
  String toString() => message;
}

import "exception.dart";
import "fraction.dart";
import "vector.dart";

class Matrix {
  final List<List<Fraction>> data;
  final int rows;
  final int cols;

  Matrix._(List<List<Fraction>> grid)
    : data = List.unmodifiable(grid.map((row) => List.unmodifiable(row))),
      rows = grid.length,
      cols = grid.first.length;

  factory Matrix(Iterable<Iterable<Object>> input) {
    if (input.isEmpty) {
      throw CalcException.isEmpty("[Ошибка] Матрица не может быть пустой.");
    }

    final grid = <List<Fraction>>[];
    int? expectedCols;

    for (final row in input) {
      final parsedRow = row.map((e) => toFraction(e)).toList();
      if (parsedRow.isEmpty) {
        throw CalcException.isEmpty("[Ошибка] Матрица не может быть пустой.");
      }

      expectedCols ??= parsedRow.length;

      if (parsedRow.length != expectedCols) {
        throw CalcException.dimension(
          "[Ошибка] Все строки матрицы должны иметь одинаковую длину.",
        );
      }

      grid.add(parsedRow);
    }

    return Matrix._(grid);
  }

  factory Matrix.zero(int rows, int cols) {
    if (rows <= 0 || cols <= 0) {
      throw CalcException.dimension(
        "[Ошибка] Размерность матрицы должна быть положительной.",
      );
    }

    return Matrix._(
      List.generate(rows, (_) => List.filled(cols, toFraction(0))),
    );
  }

  factory Matrix.identity(int size) {
    if (size <= 0) {
      throw CalcException.dimension(
        "[Ошибка] Размерность матрицы должна быть положительной.",
      );
    }

    return Matrix._(
      List.generate(
        size,
        (i) =>
            List.generate(size, (j) => i == j ? toFraction(1) : toFraction(0)),
      ),
    );
  }

  factory Matrix.fromVectors(List<Vector> vectors, [bool asColumns = true]) {
    if (vectors.isEmpty) {
      throw CalcException.isEmpty("[Ошибка] Матрица не может быть пустой.");
    }

    final size = vectors.first.size;
    for (Vector vector in vectors) {
      if (vector.size != size) {
        throw CalcException.dimension(
          "[Ошибка] Все вектора должны иметь одинаковую длину.",
        );
      }
    }

    if (asColumns) {
      return Matrix._(
        List.generate(
          size,
          (r) => List.generate(vectors.length, (c) => vectors[c][r]),
        ),
      );
    }

    return Matrix._(vectors.map((v) => v.coords).toList());
  }
}

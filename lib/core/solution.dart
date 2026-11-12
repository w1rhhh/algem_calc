sealed class Step {
  const Step();

  @override
  String toString([int depth = 0]) {
    final curr = "  " * depth;
    return switch (this) {
      Leaf(:final step) => "$curr- $step\n",
      Node(:final headline, :final leaves) =>
        "$curr* $headline\n"
            "${leaves.map((s) => s.toString(depth + 1)).join()}",
    };
  }
}

final class Node extends Step {
  final String headline;
  final List<Step> leaves;

  Node(this.headline, [List<Step> leaves = const []])
    : leaves = List.unmodifiable(leaves);
}

final class Leaf extends Step {
  final String step;
  const Leaf(this.step);
}

class Solution<T> {
  final T answer;
  final Step steps;

  Solution(this.answer, String headline, [List<Step> leaves = const []])
    : steps = Node(headline, leaves);

  @override
  String toString() => "$steps[ОТВЕТ] $answer";
}

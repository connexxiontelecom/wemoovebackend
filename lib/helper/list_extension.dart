class Range {
  const Range(this.start, this.end) : assert(start <= end);
  const Range.fromLength(int length) : this(0, length - 1);

  final int start;
  final int end;

  int get length => end - start + 1;

  List<int> toList() => List.generate(length, (i) => start + i);

  bool contains(int index) {
    return index >= start && index <= end;
  }

  @override
  String toString() => '[$start, $end]';
}

extension ListExtensions on List {
  Range get indices => Range.fromLength(this.length);
}

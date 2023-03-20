class Grade {
  int gradeIndex;

  Grade(this.gradeIndex);

  @override
  String toString() {
    return gradeNames[gradeIndex];
  }

  bool isValidGrade() {
    return gradeIndex > 0 && gradeIndex < 10;
  }
}

const gradeNames = ['N/A', 'A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-'];

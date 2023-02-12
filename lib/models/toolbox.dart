class ToolboxAvailabilities {
  final bool classSwapping;
  final bool studyParner;

  ToolboxAvailabilities({
    required this.classSwapping,
    required this.studyParner,
  });

  bool isAllDisabled() {
    return !classSwapping && !studyParner;
  }

  factory ToolboxAvailabilities.fromjson(Map<String, dynamic> json) {
    return ToolboxAvailabilities(
      classSwapping: json["class_swapping"] as bool,
      studyParner: json["study_parner"] as bool,
    );
  }
}

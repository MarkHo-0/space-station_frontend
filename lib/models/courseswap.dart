class SearchRequest {
  int id;
  int classNum;
  SearchRequest({required this.id, required this.classNum});
  factory SearchRequest.fromjson(Map<String, dynamic> json) {
    return SearchRequest(
      id: json["id"],
      classNum: json["class_num"],
    );
  }
}

class SearchRequests {
  List<SearchRequest> requestArray;
  SearchRequests(this.requestArray);
  factory SearchRequests.fromjson(Map<String, dynamic> json) {
    List<SearchRequest> requests = (json["requests"] as Iterable)
        .map((t) => SearchRequest.fromjson(t))
        .toList();
    return SearchRequests(requests);
  }
}

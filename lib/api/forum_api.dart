 Future<ThreadPage> getThreadPageData(
    String cursor, int order, int pid, int fid, String q) async {
  String Conditon = "?";
  var response;

  if (cursor != "") {         //default String="",int=-1
    Conditon = Conditon + "cursor=" + cursor;
  }
  if (order != -1) {
    Conditon = Conditon + "order=" + order.toString();
  }
  if (pid != -1) {
    Conditon = Conditon + "pid=" + pid.toString();
  }
  if (fid != -1) {
    Conditon = Conditon + "fid=" + fid.toString();
  }
  if (q != "") {
    Conditon = Conditon + "q=" + q;
  }

  if (Conditon != "?") {
    response = await http.get(Uri.parse(domain + "/thread" + Conditon));
  } else {
    response = await http.get(Uri.parse(domain + "/thread"));
  }

  if (response.statusCode == 200) {
    return ThreadPage.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ThreadPage');
  }
}

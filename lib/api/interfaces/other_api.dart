import 'package:space_station/models/toolbox.dart';

import '../http.dart';

Future<ToolboxAvailabilities> getToolboxAvailabilities() async {
  return HttpClient()
      .get('/toolbox')
      .then((res) => ToolboxAvailabilities.fromjson(res));
}

import 'package:drag_drop/src/constants/endpoints.dart';
import 'package:drag_drop/src/utils/encrypted_storage.dart';
import 'package:http/http.dart' as http;

class LevelModel {
  final int rowSize;
  final int columnSize;
  final List<NodeModel> nodes;
  final List<EdgeModel> edges;

  LevelModel({
    required this.rowSize,
    required this.columnSize,
    required this.nodes,
    required this.edges,
  });
}

Future<void> getLevel({required int id}) async {
  final response = await http.get(
      Uri.parse(GplanEndpoints.baseUrl + GplanEndpoints.levels + '/$id'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${await (EncryptedStorage().read(key: "jwt"))}"
      });

  print(response.body);
  print(response.statusCode);
}

class NodeModel {
  final int id;
  final List<List<int>> shape;

  NodeModel({required this.id, required this.shape});
}

class EdgeModel {
  final List<int> vertices;

  EdgeModel({required this.vertices});
}

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

class NodeModel {
  final int id;
  final List<List<int>> shape;

  NodeModel({required this.id, required this.shape});
}

class EdgeModel {
  final List<int> vertices;

  EdgeModel({required this.vertices});
}

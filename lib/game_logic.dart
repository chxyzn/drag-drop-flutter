class GameLogic {
  List<List<int>> initBaseMatrix(int rowSize, int columnSize) {
    List<List<int>> baseMatrix = [];

    List<int> row = List<int>.generate(columnSize, (index) {
      return 0;
    });

    for (int i = 0; i < rowSize; i++) {
      baseMatrix.add(row);
    }

    return baseMatrix;
  }

  List<List<int>> uShape(int id, int height, int width) {
    List<List<int>> shapeMatrix = [];
    List<int> row = List<int>.generate(width, (index) {
      if (index == 0 || index == width - 1) {
        return id;
      }
      return 0;
    });
    for (int i = 0; i < height; i++) {
      if (i == height - 1) {
        shapeMatrix.add(List<int>.generate(width, (index) {
          return id;
        }));
      } else {
        shapeMatrix.add(row);
      }
    }

    return shapeMatrix;
  }

  List<List<int>> tShape(int id, int height, int width) {
    List<List<int>> shapeMatrix = [];
    List<int> topRow = List<int>.generate(width, (index) {
      return id;
    });

    List<int> otherRows = List<int>.generate(width, (index) {
      if (index == width ~/ 2) {
        return id;
      }
      return 0;
    });

    for (int i = 0; i < height; i++) {
      if (i == 0) {
        shapeMatrix.add(topRow);
      } else {
        shapeMatrix.add(otherRows);
      }
    }

    return shapeMatrix;
  }

  List<List<int>> rectangle(int id, int height, int width) {
    List<List<int>> shapeMatrix = [];
    for (int i = 0; i < height; i++) {
      shapeMatrix.add(List<int>.generate(width, (index) {
        return id;
      }));
    }

    return shapeMatrix;
  }

  List<List<int>> lShape(int id, int height, int width) {
    List<List<int>> shapeMatrix = [];

    List<int> bottomRow = List<int>.generate(width, (index) {
      return id;
    });

    List<int> otherRows = List<int>.generate(width, (index) {
      if (index == 0) {
        return id;
      }
      return 0;
    });

    for (int i = 0; i < height; i++) {
      if (i == height - 1) {
        shapeMatrix.add(bottomRow);
      } else {
        shapeMatrix.add(otherRows);
      }
    }

    return shapeMatrix;
  }
}

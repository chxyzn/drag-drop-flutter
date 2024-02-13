class GameLogic {
  List<List<int>> initBaseMatrix(int rowSize, int columnSize) {
    List<List<int>> baseMatrix = [];

    for (int i = 0; i < rowSize; i++) {
      List<int> row = List<int>.generate(columnSize, (index) {
        return 0;
      });
      baseMatrix.add(row);
    }

    return baseMatrix;
  }

  List<List<int>> uShape(int id, int height, int width, int matrixSize) {
    List<List<int>> shapeMatrix = List.generate(
        matrixSize, (index) => List.generate(matrixSize, (index) => 0));

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        //two pillars of u
        if (j == 0 || j == width - 1) {
          shapeMatrix[i][j] = id;
        }
        //base of u
        if (i == height - 1) {
          shapeMatrix[i][j] = id;
        }
      }
    }

    return shapeMatrix;
  }

  List<List<int>> tShape(int id, int height, int width, int matrixSize) {
    List<List<int>> shapeMatrix = List.generate(
        matrixSize, (index) => List.generate(matrixSize, (index) => 0));

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        //horizontal line of t
        if (i == 0) {
          shapeMatrix[i][j] = id;
        }
        //vertical line of t
        if (j == width ~/ 2) {
          shapeMatrix[i][j] = id;
        }
      }
    }

    return shapeMatrix;
  }

  List<List<int>> rectangle(int id, int height, int width, int matrixSize) {
    List<List<int>> shapeMatrix = List.generate(
        matrixSize, (index) => List.generate(matrixSize, (index) => 0));

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        shapeMatrix[i][j] = id;
      }
    }

    return shapeMatrix;
  }

  List<List<int>> lShape(int id, int height, int width, int matrixSize) {
    List<List<int>> shapeMatrix = List.generate(
        matrixSize, (index) => List.generate(width, (index) => 0));

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        //vertical line of l
        if (j == 0) {
          shapeMatrix[i][j] = id;
        }
        //base of l
        if (i == height - 1) {
          shapeMatrix[i][j] = id;
        }
      }
    }

    return shapeMatrix;
  }
}

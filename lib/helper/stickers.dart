class Stickers {
  List<List<String>> list() {
    return [emotion(), heart(), rose()];
  }

  List<String> emotion() {
    List<String> list = [];
    for (int i = 1; i <= 13; i++) {
      list.add('assets/stickers/emotion ($i).png');
    }
    return list;
  }

  List<String> heart() {
    List<String> list = [];
    for (int i = 1; i <= 6; i++) {
      list.add('assets/stickers/hearts ($i).png');
    }
    return list;
  }

  List<String> rose() {
    List<String> list = [];
    for (int i = 1; i <= 6; i++) {
      list.add('assets/stickers/rose ($i).png');
    }
    return list;
  }
}

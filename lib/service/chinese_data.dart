import '../model/chinese_model.dart';

List<ChineseModel> getChinese() {
  List<ChineseModel> chinese = [];
  ChineseModel chineseModel = ChineseModel();

  chineseModel.name = "Beef Noodles";
  chineseModel.image = "images/chinese1.png";
  chineseModel.price = "60";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Chinese Gyoza";
  chineseModel.image = "images/chinese2.png";
  chineseModel.price = "70";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Beef Noodles";
  chineseModel.image = "images/chinese1.png";
  chineseModel.price = "60";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Chinese Gyoza";
  chineseModel.image = "images/chinese2.png";
  chineseModel.price = "70";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  return chinese;
}

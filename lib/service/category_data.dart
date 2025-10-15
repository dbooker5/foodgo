import '../model/category_model.dart';

List<CategoryModel> getCategories() {
  return [
    CategoryModel(image: "images/pizza.png", name: "Pizza"),
    CategoryModel(image: "images/burger.png", name: "Burger"),
    CategoryModel(image: "images/chinese.png", name: "Chinese"),
    CategoryModel(image: "images/tacos.png", name: "Mexican"),
  ];
}

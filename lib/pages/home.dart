import 'package:flutter/material.dart';
import 'package:foodgo/model/category_model.dart';
import 'package:foodgo/service/burger_data.dart';
import 'package:foodgo/service/widget_support.dart';
import '../model/burger_model.dart';
import '../model/chinese_model.dart';
import '../model/mexican_model.dart';
import '../model/pizza_model.dart';
import '../service/category_data.dart';
import '../service/chinese_data.dart';
import '../service/mexican_data.dart';
import '../service/pizza_data.dart';
import 'detail_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza = [];
  List<BurgerModel> burger = [];
  List<ChineseModel> chinese = [];
  List<MexicanModel> mexican = [];
  String track = "0";

  @override
  void initState() {
    categories = getCategories();
    pizza = getPizza();
    burger = getBurger();
    chinese = getChinese();
    mexican = getMexican();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      height: 50,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Order your favourite food!",
                      style: AppWidget.SimpleTextFieldStyle(),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                        "images/boy.jpg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                    ),
                  ),
                )
              ]
            ),
            SizedBox(height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Color(0xFFececf8),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search food item...",
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index){
                  return CategoryTile(
                        categories[index].image,
                        categories[index].name,
                        index.toString(),
                  );
                }
              ),
            ),
            SizedBox(height: 10,),
            //Pizza Selection
            track == "0"? Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.69,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 15),
                      itemCount: pizza.length,
                      itemBuilder: (context, index){
                        return FoodTile(
                            pizza[index].image!,
                            pizza[index].name!,
                            pizza[index].price!);
                      }),
              ),
              // Burger Selection
            ):track == "1"? Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15),
                    itemCount: burger.length,
                    itemBuilder: (context, index){
                      return FoodTile(
                          burger[index].image!,
                          burger[index].name!,
                          burger[index].price!);
                    }),
              ),
              //Chinese Selection
            ):track == "2"? Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15),
                    itemCount: chinese.length,
                    itemBuilder: (context, index){
                      return FoodTile(
                          chinese[index].image!,
                          chinese[index].name!,
                          chinese[index].price!);
                    }),
              ),
              //Mexican Selection
            ):track == "3"? Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15),
                    itemCount: mexican.length,
                    itemBuilder: (context, index){
                      return FoodTile(
                          mexican[index].image!,
                          mexican[index].name!,
                          mexican[index].price!);
                    }),
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }

  Widget FoodTile(String image, String name, String price){
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Center(
          child: Image.asset(
                image,
                height: 150,
                width: 150,
                fit: BoxFit.contain,
            ),
        ),
          Text(
            name,
            style: AppWidget.boldTextFieldStyle(),
          ),
          Text(
            "\$$price",
            style: AppWidget.priceTextFieldStyle(),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> DetailPage(
                              image: image,
                              name: name,
                              price: price)));
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                  child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget CategoryTile(String image, String name, String categoryindex) {
    return GestureDetector(
      onTap: (){
        track = categoryindex.toString();
        setState(() {

        });
      },
      child: track == categoryindex ?
      Container(
          margin: EdgeInsets.only(right: 20, bottom: 10),
        child: Material(
          elevation: 3,
            borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffef2b39)),
            child: Row(children: [
              Image.asset(
                  image,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover),
              SizedBox(width: 10,),
              Text(
                name,
                style: AppWidget.whiteTextFieldStyle(),
              )
            ],),
          ),
        ),
      ):Container(
        margin: EdgeInsets.only(right: 20, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Color(0xffececf8),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Row(children: [
          Image.asset(
              image,
              height: 40,
              width: 40,
              fit: BoxFit.cover),
          SizedBox(width: 10,),
          Text(
            name,
            style: AppWidget.SimpleTextFieldStyle(),
          )
        ]),
      ),
    );
  }
}

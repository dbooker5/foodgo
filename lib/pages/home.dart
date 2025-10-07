import 'package:flutter/material.dart';
import 'package:foodgo/model/category_model.dart';
import 'package:foodgo/service/widget_support.dart';
import '../service/category_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];


  @override
  void initState() {
    categories = getCategories();
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
            Container(
              height: 60,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index){
                  return CategoryTile(
                      image: categories[index].image,
                      name: categories[index].name,
                      categoryindex: index.toString(),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  String name, image, categoryindex;
  CategoryTile({required this.name, required this.image, this.categoryindex = ""});


  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  String track = "0";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        track =widget.categoryindex.toString();
        setState(() {

        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffef2b39)),
        child: Row(children: [
          Image.asset(
              widget.image,
              height: 40,
              width: 40,
              fit: BoxFit.cover),
          SizedBox(width: 10,),
          Text(
            widget.name,
            style: AppWidget.whiteTextFieldStyle(),
          )
        ],),
      ),
    );
  }
}


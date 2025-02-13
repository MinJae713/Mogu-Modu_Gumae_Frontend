import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String userName;
  final String distance;
  final String title;
  final String price;
  final String discount;
  final String moguPeople;
  final String likes;
  final String views;
  const ProductCard({
    super.key,
    required this.userName,
    required this.distance,
    required this.title,
    required this.price,
    required this.discount,
    required this.moguPeople,
    required this.likes,
    required this.views
  });

  @override
  State<StatefulWidget> createState() {
    return _ProductCard();
  }
}

class _ProductCard extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('${widget.title} 클릭됨');
        },
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Text(widget.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Text(widget.distance, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          color: Colors.grey.shade300,
                          width: 70,
                          height: 70,
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.favorite_border, color: Colors.purple, size: 16),
                            SizedBox(width: 4),
                            Text(widget.likes, style: TextStyle(color: Colors.purple)),
                            SizedBox(width: 16),
                            Icon(Icons.visibility, color: Colors.purple, size: 16),
                            SizedBox(width: 4),
                            Text(widget.views, style: TextStyle(color: Colors.purple)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFBDE9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('모구', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.price,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFB34FD1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(widget.discount, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(widget.moguPeople, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
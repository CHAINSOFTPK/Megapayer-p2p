import 'package:flutter/material.dart';
import 'package:local_coin/core/utils/dimensions.dart';
import 'package:local_coin/core/utils/my_color.dart';

class LatestResultListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String percentageChange;
  final String image;

  const LatestResultListItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.percentageChange,
    required this.image,
  }) : super(key: key);

  @override
  _LatestResultListItemState createState() => _LatestResultListItemState();
}

class _LatestResultListItemState extends State<LatestResultListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    _animation = ColorTween(
      begin: const Color.fromARGB(255, 38, 107, 106),
      end: MyColor.primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                _animation.value!.withOpacity(.5),
                _animation.value!.withOpacity(.45),
                _animation.value!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0), // No radius
                child: Image.asset(
                  widget.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: Dimensions.fontLarge,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: MyColor.colorWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: Dimensions.fontOverSmall,
                      fontFamily: 'Poppins',
                      color: MyColor.colorWhite,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.price,
                    style: TextStyle(
                      fontSize: Dimensions.fontLarge,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: MyColor.colorWhite,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.percentageChange,
                    style: TextStyle(
                      fontSize: Dimensions.fontSmall,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

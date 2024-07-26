import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  final double width;
  final bool isDarkMode;

  const searchBar({
    super.key,
    required this.width,
    required this.isDarkMode,

  });

  @override
  Widget build(BuildContext context) {

   return Positioned(
        left: 0,
        right: 0,
        bottom: 1,
        child: Column(
          children: [
            Container(
              height: 60,
              width: width - 30,
              decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF000000): const Color(0xFFB463FD),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.search_rounded,color: Colors.white,size: 40,),
                    const SizedBox(width: 10,),
                     Text("Search", style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(width: width - 195,),
                    const Icon(Icons.send,color: Colors.white,size: 30,)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14,),
          ],
        ));
  }
  }
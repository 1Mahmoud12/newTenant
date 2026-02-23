import 'package:rova_star/core/component/custom_app_bar.dart';
import 'package:rova_star/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context: context, title: 'Reviews'),
      body: const ReviewsBody(),
    );
  }
}

class ReviewsBody extends StatelessWidget {
  const ReviewsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        RatingSummary(),
        SizedBox(height: 16),
        RatingHistogram(),
        SizedBox(height: 16),
        ReviewsList(),
      ],
    );
  }
}

class RatingSummary extends StatelessWidget {
  const RatingSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '4.0',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBarIndicator(
              rating: 4.0,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: 20.0,
            ),
            const SizedBox(height: 4),
            Text(
              '1034 Ratings',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: Constants.tablet ? 16 : 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RatingHistogram extends StatelessWidget {
  const RatingHistogram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample rating distribution data
    final ratingDistribution = [
      {'stars': 5, 'percentage': 0.75},
      {'stars': 4, 'percentage': 0.15},
      {'stars': 3, 'percentage': 0.05},
      {'stars': 2, 'percentage': 0.03},
      {'stars': 1, 'percentage': 0.02},
    ];

    return Column(
      children: ratingDistribution.map((data) {
        return RatingBar(
          stars: data['stars']! as int,
          percentage: data['percentage']! as double,
        );
      }).toList(),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int stars;
  final double percentage;

  const RatingBar({
    Key? key,
    required this.stars,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          // Wrap the stars in a fixed width container to prevent overflow
          SizedBox(
            width: 55, // Fixed width for stars
            child: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min, // Take minimum required space
                children: [
                  for (int i = 0; i < stars; i++) const Icon(Icons.star, color: Colors.amber, size: 12),
                  for (int i = 0; i < (5 - stars); i++) Icon(Icons.star, color: Colors.grey[300], size: 12),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsList extends StatelessWidget {
  const ReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'name': 'Wade Warren',
        'rating': 5.0,
        'comment': 'The item is very good, my son likes it very much and plays every day.',
        'timeAgo': '6 days ago',
      },
      {
        'name': 'Guy Hawkins',
        'rating': 4.0,
        'comment': 'The seller is very fast in sending packet, I just bought it and got the item arrived in just 1 day!',
        'timeAgo': '1 week ago',
      },
      {
        'name': 'Robert Fox',
        'rating': 4.0,
        'comment': 'I just bought it and the stuff is really good! I highly recommend it!',
        'timeAgo': '2 weeks ago',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '45 Reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Row(
              children: [
                Text(
                  'Most Relevant',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: Constants.tablet ? 16 : 16.sp,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...reviews.map((review) => ReviewCard(review: review)).toList(),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBarIndicator(
            rating: review['rating'],
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemSize: 18.0,
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'],
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: Constants.tablet ? 14 : 14.sp,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                review['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Constants.tablet ? 16 : 16.sp,
                ),
              ),
              Text(
                ' • ${review['timeAgo']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:giro_driver_app/features/earnings/models/earnings_details.dart';
import 'package:giro_driver_app/features/earnings/providers/earnings_provider.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:provider/provider.dart';

class EarningsReportScreen extends StatelessWidget {
  const EarningsReportScreen({Key? key, required this.bookingId})
      : super(key: key);
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EarningsProviders>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ride Details'),
        ),
        body: FutureBuilder<EarningsDetails>(
            future: provider.showEarningsDetails(bookingId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // indicating that the async operation has begun
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                // When async operation is completed.
                case ConnectionState.done:
                default:
                  //if snapshot has data
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final bookingDeails = data.bookingDetails;
                    final customerDetails = data.customer;
                    double rating = 0;
                    try {
                      rating = double.parse(bookingDeails.starRating ?? '0');
                    } catch (_) {}

                    return ListView(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1e000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#${bookingDeails.bookingId}',
                                  style: heading3Style.copyWith(
                                      color: kcMediumGreyColor)),
                              vSpace10,
                              DataBlock(
                                  value: bookingDeails.fromLocation,
                                  title: 'From'),
                              DataBlock(
                                  value: bookingDeails.toLocation, title: 'To'),
                              DataBlock(
                                  value: customerDetails.name,
                                  title: 'Customer'),
                              DataBlock(
                                  value: bookingDeails.nightRide=='0'?'Normal Ride': 'Night Ride',
                                  title: 'Night Ride Status'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.fare}',
                                  title: 'Fare'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.tax}',
                                  title: 'Tax'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.serviceCharge}',
                                  title: 'Service Charege'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.totalFare}',
                                  title: 'Total Fare'),
                              DataBlock(
                                  value: '${bookingDeails.driverPercent} %',
                                  title: 'Earning Pecentage'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.extraRideFee}',
                                  title: 'Extra Charges'),
                              DataBlock(
                                  value: '₹ ${bookingDeails.waitingCharge}',
                                  title: 'Waiting Charges'),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Review',
                                          style: bodyStyleBold.copyWith(
                                              color: Colors.black26)),
                                    ],
                                  ),
                                  RatingBar(
                                    initialRating: rating,
                                    maxRating: 5,
                                    itemSize: 30,
                                    ignoreGestures: true,
                                    ratingWidget: RatingWidget(
                                      full: const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      half: const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      empty: const Icon(
                                        Icons.star_outline,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  Text(bookingDeails.review ?? 'No reviews',
                                      style: bodyStyle),
                                  const Divider(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  //if snapshot has error
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Something went wrong ${snapshot.error.toString()}'));
                  }
                  //if snapshot is null
                  return const Center(child: Text('No data found'));
              }
            }));
  }
}

class DataBlock extends StatelessWidget {
  const DataBlock({
    super.key,
    required this.value,
    required this.title,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: bodyStyleBold.copyWith(color: Colors.black26)),
        Text(value, style: heading3Style),
        const Divider(),
      ],
    );
  }
}

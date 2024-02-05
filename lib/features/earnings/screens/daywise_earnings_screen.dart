import 'package:flutter/material.dart';
import 'package:giro_driver_app/features/earnings/models/trip_history.dart';
import 'package:giro_driver_app/features/earnings/providers/earnings_provider.dart';
import 'package:giro_driver_app/features/earnings/screens/earnings_report_sreen.dart';
import 'package:giro_driver_app/theme/app_widgets/app_input_field.dart';
import 'package:giro_driver_app/theme/colors/app_colors.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';
import 'package:giro_driver_app/theme/white_space/space_helper.dart';
import 'package:giro_driver_app/utils/form_validators/form_validators.dart';
import 'package:giro_driver_app/utils/route/app_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EarningsProviders>();
    var date = DateTime.now();
    final dataString = "${date.toLocal()}".split(' ')[0];
    provider.dobController.text = dataString;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Future.delayed(Duration.zero, () {
              _selectDate(context, provider.selectedDate, provider.updateDate);
            }),
            child: AbsorbPointer(
              child: InputField(
                validator: FormValidator.validate,
                controller: provider.dobController,
                trailing: const Icon(Icons.calendar_month_outlined),
              ),
            ),
          ),
          Expanded(
              child: Selector<EarningsProviders, DateTime>(
            builder: (context, value, child) => FutureBuilder<RideHistory>(
                future: provider.getEarningByDate(),
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
                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: [
                            Text('Earnings',
                                style: bodyStyleBold.copyWith(
                                    color: Colors.black26)),
                            Text('₹ ${data.earnings}',
                                style:
                                    heading3Style.copyWith(color: kcPrimary)),
                            ExpansionTile(
                              title: Text('Completed : ${data.completedRides}',
                                  style: heading3Style),
                              children: [
                                ...data.completedRidesList
                                    .map((e) => TripCard(
                                          tripDetails: e,
                                          status: 'Completed',
                                        ))
                                    .toList(),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                'Rejected : ${data.rejectedRides}',
                                style: heading3Style,
                              ),
                              children: [
                                ...data.unfinishedRidesList
                                    .where((e) => e.status == '2')
                                    .toList()
                                    .map((e) => TripCard(
                                          tripDetails: e,
                                          status: 'Rejected',
                                        ))
                                    .toList(),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                'Cancelled : ${data.cancelledRides}',
                                style: heading3Style,
                              ),
                              children: [
                                ...data.unfinishedRidesList
                                    .where((e) => e.status == '3')
                                    .toList()
                                    .map((e) => TripCard(
                                          tripDetails: e,
                                          status: 'Cancelled',
                                        ))
                                    .toList(),
                              ],
                            ),
                            ExpansionTile(
                              title: Text(
                                'Timeout : ${data.timeoutRides}',
                                style: heading3Style,
                              ),
                              children: [
                                ...data.unfinishedRidesList
                                    .where((e) => e.status == '4')
                                    .toList()
                                    .map((e) => TripCard(
                                          tripDetails: e,
                                          status: 'Timeout',
                                        ))
                                    .toList(),
                              ],
                            )
                          ],
                        );
                      }
                      //if snapshot has error
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                      //if snapshot is null
                      return const Center(child: Text('No data found'));
                  }
                }),
            selector: (p0, p1) => p1.selectedDate,
          ))
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime selectedDate,
      void Function(DateTime) onChanged) async {
    DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 3),
        lastDate: today);
    if (picked != null && picked != selectedDate) {
      onChanged(picked);
      selectedDate = picked;
    }
  }
}

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.tripDetails, required this.status});
  final RideModel tripDetails;
  final String status;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status == 'Completed' ?() => MyRouter.push(
          screen: EarningsReportScreen(bookingId: tripDetails.id)):null,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#${tripDetails.bookingId}',
                  style: heading3Style.copyWith(color: kcMediumGreyColor)),
              vSpace10,
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: kcSuccess,
                    size: 15,
                  ),
                  hSpace10,
                  Expanded(
                    child: Text(
                      tripDetails.fromLocation,
                      style: bodyStyleBold,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: kcPrimary,
                    size: 15,
                  ),
                  hSpace10,
                  Expanded(
                    child: Text(
                      tripDetails.toLocation,
                      style: bodyStyleBold,
                    ),
                  )
                ],
              ),
              vSpace10,
              if(status == 'Completed')
              Text(DateFormat.yMd()
                  .add_jm()
                  .format(tripDetails.bookedAt.toLocal())
                  .toString()),
              vSpace10,
              Text(
                status,
                style: captionStyle.copyWith(
                    color: status == 'Completed' ? kcSuccess : kcDanger),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTracker extends StatefulWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTracker({
    super.key,
    required this.habitName,
    required this.habitStarted,
    required this.onTap,
    required this.settingsTapped,
    required this.timeGoal,
    required this.timeSpent,
  });

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  // convert seconds into min:sec -> eg 62 seconds = 1:02min

  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    // if secs is a 1 digit number, place a 0 infront of it

    if (secs.length == 1) {
      secs = '0' + secs;
    }

    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return mins + ' : ' + secs;
  }

  //calculate progress percentage

  double percentComplete() {
    return widget.timeSpent / (widget.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        CircularPercentIndicator(
                          radius: 30,
                          percent:
                              percentComplete() < 1 ? percentComplete() : 1,
                          progressColor: percentComplete() > 0.5
                              ? (percentComplete() > 0.75
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.red,
                        ),
                        Center(
                          child: Icon(widget.habitStarted
                              ? Icons.pause
                              : Icons.play_arrow),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      formatToMinSec(widget.timeSpent) +
                          ' / ' +
                          widget.timeGoal.toString() +
                          ' = ' +
                          (percentComplete() * 100).toStringAsFixed(0) +
                          '%',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: widget.settingsTapped,
              child: const Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

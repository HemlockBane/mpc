import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardUtil {

  static String getTimeOfDay() {
    final timeOfDay = TimeOfDay.now();
    int hour = timeOfDay.hour;

    if (hour > 0 && hour < 12) {
      return "Morning";
    }
    if (hour >= 12 && hour < 17) {
      return "Afternoon";
    }
    if(hour < 19 && hour >= 17) {
      return "Sunset";
    }
    return "Evening";
  }

  static Widget getGreetingIcon(String timeOfDay) {
    if (timeOfDay == "Morning") {
      return SvgPicture.asset('res/drawables/ic_time_of_day_morning.svg');
    } else if (timeOfDay == "Afternoon") {
      return SvgPicture.asset('res/drawables/ic_time_of_day_afternoon.svg');
    } else if (timeOfDay == "Sunset") {
      return SvgPicture.asset('res/drawables/ic_time_of_day_sunset.svg');
    } else if (timeOfDay == "Evening") {
      return SvgPicture.asset('res/drawables/ic_time_of_day_evening.svg');
    } else
      return SvgPicture.asset('res/drawables/ic_time_of_day_morning.svg');
  }
}
import 'package:intl/intl.dart';

class TimeAgo {
  static const int SECOND_MILLIS = 1000;
  static const int MINUTE_MILLIS = 60 * SECOND_MILLIS;
  static const int HOUR_MILLIS = 60 * MINUTE_MILLIS;
  static const int DAY_MILLIS = 24 * HOUR_MILLIS;

  static String formatDuration(int milliseconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    if(time.day > 0) {
      return DateFormat("d MMM, h:mm a").format(time);
    }
    return getTimeAgo(milliseconds);
  }

  static String getTimeAgo(int time) {
    if (time < 1000000000000) {
      time *= 1000;
    }

    int now = DateTime.now().millisecondsSinceEpoch;//Calendar.getInstance(TimeZone.getDefault()).getTimeInMillis();
    if (time > now || time <= 0) {
      return "";
    }

    final int diff = now - time;
    if (diff < MINUTE_MILLIS) {
      return "just now";
    } else if (diff < 2 * MINUTE_MILLIS) {
      return "a minute ago";
    } else if (diff < 50 * MINUTE_MILLIS) {
      return "${diff / MINUTE_MILLIS} minutes ago";
    } else if (diff < 90 * MINUTE_MILLIS) {
      return "an hour ago";
    } else if (diff < 24 * HOUR_MILLIS) {
      num value = diff / HOUR_MILLIS;
      return (value <= 1) ? "an hour ago" : "$value hours ago";
    } else if (diff < 48 * HOUR_MILLIS) {
      return "yesterday";
    } else {
      return "${diff / DAY_MILLIS} days ago";
    }
  }
}
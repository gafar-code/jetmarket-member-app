import 'package:intl/intl.dart';

extension DateFormatExtension on String {
  String timeAgo() {
    String formattedDate = split('.')[0];
    String cleanedDate = formattedDate.replaceAll("+0000 +0000", "").trim();
    DateTime createdAt = DateTime.parse(cleanedDate).toLocal();
    DateTime now = DateTime.now().toLocal();
    Duration difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} Menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} Jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 2) {
      return 'Kemarin';
    } else if (difference.inDays >= 2) {
      return DateFormat('dd/MM/yyyy').format(createdAt);
    } else {
      return 'Tidak diketahui';
    }
  }

  String timeAgoChat() {
    String formattedDate = split('.')[0];
    String cleanedDate = formattedDate.replaceAll("+0000 +0000", "").trim();
    DateTime createdAt = DateTime.parse(cleanedDate).toLocal();
    DateTime now = DateTime.now().toLocal();
    Duration difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      String formattedTime =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      return formattedTime;
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 2) {
      return 'Kemarin';
    } else {
      return DateFormat('dd/MM/yyyy').format(createdAt);
    }
  }
}

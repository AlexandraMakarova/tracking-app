part of 'helpers.dart';

void loadingAlert(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Please wait'),
        content: Text('Calculating route'),
      ),
    );
  } else {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Please wait'),
              content: CupertinoActivityIndicator(),
            ));
  }
}

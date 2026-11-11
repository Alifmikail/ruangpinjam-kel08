/// Alamat API dibaca dari --dart-define=API_URL=...
/// Default 10.0.2.2 adalah alamat laptop jika dilihat dari emulator Android.
const String apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8080',
);

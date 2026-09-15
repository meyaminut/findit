const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String formatTanggalWaktu(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]} · $hh:$mm';
}

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';
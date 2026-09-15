enum FoundItemStatus { baruDitemukan, disimpanLostFound, dikembalikan }

extension FoundItemStatusX on FoundItemStatus {
  String get label => switch (this) {
        FoundItemStatus.baruDitemukan => 'Baru Ditemukan',
        FoundItemStatus.disimpanLostFound => 'Disimpan di Lost & Found',
        FoundItemStatus.dikembalikan => 'Dikembalikan ke Pemilik',
      };
}

enum FoundItemCategory {
  elektronik,
  pakaian,
  aksesoris,
  dokumen,
  lainnya;

  String get label => switch (this) {
        FoundItemCategory.elektronik => 'Elektronik',
        FoundItemCategory.pakaian => 'Pakaian',
        FoundItemCategory.aksesoris => 'Aksesoris',
        FoundItemCategory.dokumen => 'Dokumen',
        FoundItemCategory.lainnya => 'Lainnya',
      };
}

class FoundItem {
  FoundItem({
    required this.id,
    required this.namaBarang,
    required this.category,
    required this.warna,
    required this.deskripsi,
    required this.lokasi,
    required this.ditemukanPada,
    this.status = FoundItemStatus.baruDitemukan,
    this.photoPath,
  });

  final String id;
  final String namaBarang;
  final FoundItemCategory category;
  final String warna;
  final String deskripsi;
  final String lokasi;
  final DateTime ditemukanPada;
  FoundItemStatus status;
  final String? photoPath;
}
import '../models/found_item.dart';

List<FoundItem> mockFoundItems() => [
      FoundItem(
        id: '1',
        namaBarang: 'Jam Tangan Silver',
        category: FoundItemCategory.aksesoris,
        warna: 'Perak dengan tali kulit hitam',
        deskripsi: 'Ditemukan di atas meja lobby dekat resepsionis, kondisi baik.',
        lokasi: 'Lobby Utama',
        ditemukanPada: DateTime.now().subtract(const Duration(hours: 2)),
        status: FoundItemStatus.baruDitemukan,
      ),
      FoundItem(
        id: '2',
        namaBarang: 'Dompet Kulit Coklat',
        category: FoundItemCategory.dokumen,
        warna: 'Coklat tua',
        deskripsi: 'Berisi KTP dan beberapa kartu ATM. Diserahkan ke lost & found.',
        lokasi: 'Restoran Lantai 2',
        ditemukanPada: DateTime.now().subtract(const Duration(days: 1)),
        status: FoundItemStatus.disimpanLostFound,
      ),
      FoundItem(
        id: '3',
        namaBarang: 'Power Bank Hitam 10000mAh',
        category: FoundItemCategory.elektronik,
        warna: 'Hitam',
        deskripsi: 'Ditemukan mencolok di stop kontak dekat sofa area tunggu.',
        lokasi: 'Kamar 1204',
        ditemukanPada: DateTime.now().subtract(const Duration(days: 2)),
        status: FoundItemStatus.disimpanLostFound,
      ),
      FoundItem(
        id: '4',
        namaBarang: 'Kaos Putih Ukuran M',
        category: FoundItemCategory.pakaian,
        warna: 'Putih',
        deskripsi: 'Terlipat rapi di meja dekat kolam renang, masih baru.',
        lokasi: 'Area Kolam Renang',
        ditemukanPada: DateTime.now().subtract(const Duration(days: 3)),
        status: FoundItemStatus.dikembalikan,
      ),
    ];
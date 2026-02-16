Prinsip SRP sangat membantu saya dalam membuat perubahan atau menambahkan fitur. Saat menambahkan History Logger, saya jadi tahu bagaimana memisahkan tugasnya:

1. Di Controller: Saya fokus pada logika menambahkan list dan membatasi 5 data terakhir.

2. Di View : Saya fokus pada bagaimana data tersebut ditampilkan seperti memberikan warna hijau atau merah dan tata letak Card.

SRP juga membuat code saya lebih mudah dibaca dan diperbaiki. Jika ada kesalahan warna, saya cukup mencari di file view tanpa harus takut merusak logika di file controller.



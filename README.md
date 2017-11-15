# Tugas 2 IF3110 Pengembangan Aplikasi Berbasis Web

Melakukan *upgrade* Website ojek online sederhana pada Tugas 1 dengan mengaplikasikan **arsitektur web service REST dan SOAP**.

## Memasang *development environment*

### Java 8 SDK

See [https://medium.com/coderscorner/installing-oracle-java-8-in-ubuntu-16-10-845507b13343].

### IntelliJ IDEA Ultimate (2017.1.3 or later)

1. Apply for JetBrains Products for Learning: [https://www.jetbrains.com/shop/eform/students]
2. Download IntelliJ IDEA Ultimate from [https://www.jetbrains.com/idea/download]
3. Install: [https://www.jetbrains.com/help/idea/installing-and-launching.html]

### GlassFish 5.0

1. Download GlassFish 5.0 Full Platform: [http://download.java.net/glassfish/5.0/release/glassfish-5.0.zip]
2. Extract ZIP to `/opt`: `sudo unzip glassfish-5.0.zip -d /opt`
3. Add write permissions to domains directory: `sudo chmod o+w /opt/glassfish5/domains -R`

Note: if using Docker, GlassFish 5.0 is only required for the GlassFish integration plugin to find required JARs.

### Menjalankan pada Docker

Prerequisites:
- [https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository](Docker CE)
- [https://docs.docker.com/compose/install/#install-compose](Docker Compose)

For development (combined in Docker Compose), run `docker-compose up` in the repository directory.
GlassFish and MySQL is now running:
- WebApp: port 8000, GlassFish admin page at 48480
- IdentityService: port 8001, GlassFish admin page at 48481, PHPMyAdmin at 12341
- WebService: port 8002, GlassFish admin page at 48482, PHPMyAdmin at 12342

You can now run each application using the `GlassFish 5.0.0 on Docker` task in IntelliJ IDEA.

To run each application separately:
1. Change directory using `cd WebApp`, `cd WebService`, or `cd IdentityService`
2. `docker-compose up` in the project directory
3. Run the `GlassFish 5.0.0 on Docker` task in IntelliJ IDEA for each application

### MySQL/MariaDB (tanpa Docker)

See [https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-16-04].
Or install using LAMPP: [https://www.apachefriends.org/faq_linux.html].

## Tujuan Pembuatan Tugas

Diharapkan dengan tugas ini kami dapat mengerti:
* Produce dan Consume REST API
* Mengimplementasikan service Single Sign-On (SSO) sederhana
* Produce dan Consume Web Services dengan protokol SOAP
* Membuat web application dengan menggunakan JSP yang akan memanggil web services dengan SOAP (dengan JAX-WS) dan REST (dengan Servlet).

## Arsitektur Umum Server
![Gambar Arsitektur Umum](arsitektur_umum.png)

Tugas 2 ini terdiri dari berberapa komponen yang harus dibuat:
* `Web app`: digunakan untuk menangani HTTP request dari web browser dan menghasilkan HTTP response. Bagian yang diimplementasi dengan JSP ini juga bertugas untuk meng-generate tampilan web layaknya PHP. Bagian ini wajib dibuat dengan **Java + Java Server Pages**. Maka dari itu, konversi seluruh kode PHP pada tugas 1 menjadi kode JSP.
* `Ojek Online Web Service`: digunakan sebagai interface yang dipanggil oleh aplikasi melalui protokol SOAP. melakukan query ke database, operasi insert, dan operasi update untuk entitas User, History, dan Preferred Locations. Webservice ini akan dipanggil oleh aplikasi dengan menggunakan SOAP. Webservice ini wajib dibuat dengan **JAX-WS dengan protokol SOAP atau Webservice lain** yang basisnya menggunakan **SOAP dan Java**.
* `Identity service`: dipanggil oleh aplikasi untuk menerima email (sebagai username) dan password pengguna, dan menghasilkan *access token*. Identity Service juga dipanggil oleh *ojek online web service* untuk melakukan validasi terhadap *access token* yang sedang dipegang oleh *web app*. Service ini dibuat menggunakan REST. Namun, selain menghandle request secara REST biasa, Identity Service juga harus bisa **menerima SOAP request dan mengembalikan SOAP response**. Identity service ini wajib dibuat dengan menggunakan **Java Servlet**.
* `Database`: basis data yang telah dibuat pada tugas 1 dipisahkan menjadi basis data khusus manajemen *account* (menyimpan username, password, dkk) dan basis data ojek online tanpa manajemen *account*. Basis data *account* digunakan secara khusus oleh Identity Service. **Ojek Online Web Service tidak boleh secara langsung mengakses basis data account untuk melakukan validasi token** (harus melalui Identity Service).

## Deskripsi Tugas

Kami diminta untuk membuat ojek online sederhana seperti tugas 1.  Kebutuhan fungsional dan non-fungsional tugas yang harus dibuat adalah sebagai berikut.

1. Halaman website yang memiliki tampilan serupa dengan tugas 1.
2. Ojek Online web service dengan fungsi-fungsi sesuai kebutuhan sistem dalam mengakses data (kecuali login, register, dan logout).
3. Identity service yang menangani manajemen *account* seperti login dan register, serta validasi access token.
4. Fitur validasi email dan username pada halaman register tidak perlu diimplementasikan dengan menggunakan AJAX.
5. Tidak perlu melakukan validasi javascript.
6. Tampilan pada tugas ini **tidak akan dinilai**. Sangat disarankan untuk menggunakan asset dan tampilan dari tugas sebelumnya. Boleh menggunakan CSS framework seperti Bootstrap atau javascript library seperti jQuery.
7. Tidak perlu memperhatikan aspek keamanan dan etika penyimpanan data.

### Skenario

#### Login
1. Pengguna mengakses halaman login : `/login.jsp` dan mengisi form.
2. JSP akan membuka HTTP request ke Identity Service dengan body data username dan password.
3. Identity service akan melakukan query ke DB untuk mengetahui apakah username dan password tersebut valid.
4. Identity service akan memberikan HTTP response `access token` dan `expiry time` jika username dan password ada di dalam DB, atau error jika tidak ditemukan data.`expiry time` berdurasi 1 jam.
5. Access token ini digunakan sebagai representasi state dari session pengguna dan harus dikirimkan ketika pengguna ingin melakukan semua aktivitas, kecuali login, register, dan logout. 
6. Access token digenerate secara random.
7. Access token dikirimkan bersama request dan dapat diambil untuk melakukan aktivitas.

#### Register
1. Pengguna mengakses halaman register : `/register.jsp` dan mengisi form.
2. JSP akan melakukan HTTP request ke Identity Service dengan body data yang dibutuhkan untuk registrasi.
3. Identity service akan query DB untuk melakukan validasi bahwa email dan username belum pernah terdaftar sebelumnya.
4. Identity service akan menambahkan user ke DB bila validasi berhasil, atau memberi HTTP response error jika username sudah ada atau confirm password salah.
5. Identity service akan memberikan HTTP response `access token` dan `expiry time` dan user akan ter-login ke halaman profile bila user merupakan driver atau ke halaman order bila user bukan merupakan driver.

#### Logout
1. Pengguna menekan tombol logout.
2. JSP akan melakukan HTTP request ke Identity Service dengan body data yang dibutuhkan.
3. Identity service akan menghapus atau melakukan invalidasi terhadap access token yang diberikan.
4. Identity service akan mengembalikan HTTP response berhasil.
5. Halaman di-*redirect* ke halaman login.

#### Add Preferred Location, Make an Order, dll
1. Pengguna mengakses halaman add preferred location : `/edit-preferred-location.jsp` dan mengisi form.
2. JSP akan memanggil fungsi pada *ojek online web service* dengan SOAP : `addPreferredLocation(access_token, loc_name)`.
3. Fungsi tersebut akan melakukan HTTP request ke Identity Service, untuk mengenali user dengan `access_token` yang diberikan.
    - Jika `access_token` **kadaluarsa**, maka `addPreferredLocation` akan memberikan response expired token.
    - Jika `access_token` **tidak valid**, maka `addPreferredLocation` akan memberikan response error ke JSP.
    - Jika `access_token` **valid**, maka `addPreferredLocation` akan memasukan produk ke DB, dan memberikan response kesuksesan ke JSP.
4. Jika `access_token` sudah kadaluarsa atau tidak valid (yang diketahui dari response error ojek online web service), sistem akan me-redirect user ke halaman login.
5. Untuk make an order, get history, dan lainnya kira-kira memiliki mekanisme yang sama dengan add preferred locations di atas.

### *Auto-renew* access token

Pada spesifikasi asli, *access token* hanya berlaku selama periode waktu tertentu sebelum *expiry time* yang cukup singkat. Hal ini dimaksudkan agar apabila *access token* berhasil diperoleh oleh orang lain selain pengguna yang sebenarnya (*attacker*), dampaknya seminimum mungkin karena terbatas waktu. Akan tetapi, hal ini tentu saja tidak praktis bagi pengguna karena akan terlogout setiap kali *expiry time* habis.

Untuk mengatasi hal tersebut, digunakan sistem *refresh token* untuk me-*renew* *access token*. Pada saat login, identity service akan memberikan sebuah *refresh token* kepada web app (JSP). Setiap kali web app gagal membaca data dari web service (SOAP) karena *access token*-nya *expired*, maka web app akan meminta *access token* baru kepada identity service dengan menggunakan *refresh token* yang dimilikinya.

Keuntungan dari menggunakan metode ini adalah bahwa pengguna tidak harus login menggunakan username dan password terus-menerus, dan dengan demikian mengurangi resiko password tersadap oleh orang lain. *Refresh token* juga lebih aman karena hanya diketahui oleh identity service dan web app saja.

### Penjelasan

1. Basis data dari sistem yang dibuat.
	* Terdapat 2 basis data : Database Ojek Online & Database Account
	* Database Ojek Online diakses melalui Ojek Online Web Service, dan Database Account diakses melalui Identity Service
	* Database Ojek Online terdiri atas 3 tabel : *orders*, *users*, dan *user_preferred_locations*
	* Database Account terdiri atas 2 tabel : *session*, dan *users*
2. Konsep shared session dengan menggunakan REST.
	* Ketika login, pengguna akan digenerate dan diberikan sebuah *access_token* untuk mevalidasi aktivitas-aktivitas selanjutnya.
	* Ketika pengguna akan melakukan sebuah aktivitas (misal: make an order), *web service* akan memanggil *identity service* untuk melakukan validasi terhadap *access token* yang sedang dipegang oleh *web app*. 
	* *Identity service* akan mengembalikan status token yang diterima, yaitu *valid*, *invalid*, atau *expired*.
	* Apabila token tersebut *invalid*, pengguna akan di-*redirect* ke halaman login.
	* Apabila token *valid*, maka pengguna dapat melanjutkan aktivitasnya tersebut.
	* Apabila token *expired*, token akan di-*renew* dan dapat melanjutkan aktivitasnya tersebut.
3. Pembangkitan token dan expire time pada sistem yang anda buat.
	* Token di generate secara random dengan menggunakan SecureRandom (SHA1PRNG).
	* Token memiliki *expire time* selama 1 jam.
	* Apabila *identity service* menerima token yang *expired*, maka access token akan di-*renew* (lihat bagian *auto-renew* access token diatas)
4. Kelebihan dan kelemahan dari arsitektur aplikasi tugas ini, dibandingkan dengan aplikasi monolitik (login, CRUD DB, dll jadi dalam satu aplikasi)
	Arsitektur aplikasi tugas ini menerapkan arsitektur *microservice*. Penerapan ini merupakan pembangunan aplikasi dengan memecah-mecahnya menjadi bagian-bagian kecil, yang juga disebut sebagai *service*.

	Dalam *microservice*, setiap *service* dapat dikembangkan dan dites masing-masing. Antara *service* yang satu dengan yang lain berkomunikasi menggunakan sebuah protokol seperti SOAP dan REST (seperti yang telah dibuat dalam aplikasi ini).
	Setiap *service* jika diinginkan dapat dikembangkan dalam bahasa yang berbeda-beda. Selain itu, *microservice* juga mudah untuk dikembangkan lebih besar jika dibutuhkan.

	Walaupun begitu, *microservice* juga memiliki kekurangan dibandingkan dengan arsitektur *monolithic*.
	Pengembangan *microservice* tidaklah sederhana. *Microservice* memiliki banyak operasi, membutuhkan skill DevOps yang baik, dan susah untuk di-*manage* karena sistem yang terdistribusi.

### Pembagian Tugas

*REST:*
1. Generate token - 13515004
2. Validasi token - 13515004
3. Login - 13515004
4. Register - 13515004
5. Logout - 13515001
6. Auto-renew access token (bonus) - 13515001

*SOAP:*
1. Get profile - 13515004
2. Edit profile - 13515001, 13515079
3. Add preferred location - 13515001
4. Edit preferred location - 13515001
5. Delete preferred location - 13515001
6. Get preferred driver - 13515004
7. Get driver - 13515004
8. Complete order - 13515004
9. Get previous order (history penumpang) - 13515079
10. Hide previous order - 13515079
11. Get history driver - 13515079
12. Hide history driver - 13515079

*Web app (JSP):*
1. Login - 13515004
2. Register - 13515004
3. Header - 13515004
4. Profile - 13515004
5. Edit Profile - 13515001, 13515079
6. Edit Preferred Location - 13515001
7. Order Header - 13515004
8. Order Ojek - 13515004
9. Select Driver - 13515004
10. Complete Order - 13515004
11. History Header - 13515079
12. History Penumpang - 13515079
13. History Driver - 13515079

Lain-lain:
1. Setup *project* dan Docker - 13515001

## Referensi

- [https://docs.oracle.com/javaee/7/tutorial/]
- [https://www.jetbrains.com/help/idea/developing-a-java-ee-application.html]
- [https://www.jetbrains.com/help/idea/web-services.html]
- [https://www.jetbrains.com/help/idea/web-service-clients.html]
- [https://www.gitignore.io/api/java-web%2Cintellij]
- [https://www.digitalocean.com/community/tutorials/how-to-install-glassfish-4-0-on-ubuntu-12-04-3]

## About

**Kelompok 1 K-01 / Sceptre**

- 13515001 - Jonathan Christopher
- 13515004 - Jordhy Fernando
- 13515079 - Nicholas Thie

Dosen: Yudistira Dwi Wardhana | Riza Satria Perdana | Muhammad Zuhri Catur Candra
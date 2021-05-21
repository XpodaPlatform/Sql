# SQL Fonksiyon Kütüphanesi


Bu kütüphanede Octopod Kurumsal İş Uygulamaları Platformunda sıklıkla kullanılan SQL prosedür ve fonksiyonlarını içermektedir.
--

Fonksiyonlar Genel ve Entegrasyonlar olarak bölünmüştür. Entegrasyonlar altında Mikro entegrasyonlarında sık kullanılan sorgulara erişebilirsiniz.



## Data

Ortak kullanılan ve bir çok projede geliştiricinin gereksinim duyabileceği verilerin SQL formatında burada bulunmasının faydalı olacağını düşünüyoruz. 


---
**Turkiye_SehirIlceMahalle**

    Bu veri içerisinde Türkiye'nin İl, İlçe ve Mahalle verileri bulunmaktadır.



## Genel

Octopod Platformunda geliştirme yapan geliştiricinin ihtiyaç duyabileceği sık kullanılan fonksiyon ve sorguları burada grupladık. 

--- 

**EAN**

    Verilen bir barkodu EAN barkoda çevirir. 

    TODO : DOĞRU MU?

**Amazon SNS ile SMS gönderimi**

    Bu metod arka planda bir Exe çalıştırmaktadır. Eğer SMS gönderimi için bu metodu kullanacaksanız bu Exeye ihtiyaç duyacaksınız. Exeye EMS ARGE AZURE hesabından erişilebilir. Aynı zamanda Amazon SNS hesabı da gerekmektedir.

**Ayrac-Split**

    Verilen bir stringi belirtilen ayraca göre tabloya çevirir. Örnek kalem,balon,pergel olarak verilen string virgül ayracı ile bölündüğünde

    - 1- kalem
    - 2- balon
    - 3- pergel

    olarak dönecektir.


**Barkod Oluşturma**

    TODO: DÖKÜMAN YAZ

**Calisilmasi Gereken Is Gunu**

    Verilen iki tarih arasında çalışılması gereken iş günü sayısını döner.

**Client Aktif Kullanıcı Kontrolü**

    /*Son 1 saat içerisinde bir işlem yapmamış olanların UserID lerini buluyoruz.*/

**Çok Satırı Tek Satırda Gösterme**

    TODO: DÖKÜMAN YAZ

**Coklu Secim Kullanici Isimleri**

    Çoklu seçim kontrolünde kullanabilecek şekilde Client Users'ları döner.

**Cursor Ornek**

    Döngü vb amaçlı sıkça kullanılan bir CURSOR örneği.

**Dakikayı Saate Çevirme**

    Bu fonksiyon verilen SANİYEyi saat olarak döner.

**Iskonto ve Satış Çarpanlı Net Fiyat Hesaplama**

    TODO : DÖKÜMAN YAZ

**KANBAN - Takvim**

    TODO : DÖKÜMAN YAZ

**Ozel Gunler**

    Bu fonksiyon tablo olarak özel günleri (Örn: Sonraki Ayın İlk Günü) döner.

**SQL objeleri içinde arama**

    Herhangi bir sql objesini arar. 

**Yeni Client Kullanici**

    Yeni bir Client Kullanıcısı ekler. XPODA_CLIENT_USERS tablosuna ekleme yapar.

.

### Flows

İş akışlarıyla ilgili Sqller bu dizinde bulunmaktadır.

**AKIS-dinamik tablo birlestirme**

    TODO: DÖKÜMAN YAZ

**AKIS-dinamik tablo birlestirme-2**

    TODO : DÖKÜMAN YAZ


.
## Entegrasyonlar

Entegrasyonlar Octopod platformunun diğer platformlardan veri okuması ya da veri yazması ile ilgili Sql sorgu ve ifadeleridir. Şimdilik burada sadece Mikro sorguları bulunmakla birlikte zaman içerisinde Logo yazılımlarına ya da diğer 3.parti yazılımlara ilişkin sorgular da eklenebilir.

.

### Mikro Entegrasyonları

Mikro platformu, Octopod platformunun en yoğun şekilde entegre olduğu platformdur. Geliştiricinin ihtiyaç duyabileceği çeşitli SQL leri burada topladık.

--- 

**Mikro- Depolar Arası Sevkleri Mikroya Aktarma**

    Depolar arası sevkleri Mikroya aktarır. 
    
    Gereksinimler:
    ---
    fn_DatePart
    fn_FirmaAlternatifDovizKuru
    fn_NK_CARI_KODU
    ---
    Orijinal Proje : MCM

**Mikro Alınan Sipariş Insert ve Update**

    Alınan siparişleri Mikroya aktarır. 
    
    Orijinal Proje : MCM

**Mikro Cari Koduna Göre İsim Bulma**

    Verilen cari koduna göre cari ismini döner. 
    
    Orijinal Proje : Nikel

**Mikro Satış ve İrsaliye Faturası**

    Satış ve İrsaliye Faturalarını Mikroya aktarır. 
    
    Orijinal Proje : TEGV

**Mikro Çiftay Cari Personal Insert**

    Cari personel ekler. 
    
    Orijinal Proje : Çiftay

**Mikro Çiftay Depolar Arası Sevk Oluşturma**

    Yapılan tedarik hareketlerini Mikroya aktarır. 
    
    Orijinal Proje : Çiftay

**Mikro Ciftay Personel Insert**

    Personel ekleme. Bu yukarıdaki metodu çağırıyor. 
    
    Orijinal Proje : Çiftay

**Mikro Çiftay Depolar Arası Sipariş Oluşturma**

    Octopod'da oluşmuş depolar arası siparişleri Mikro'ya aktarır. Burada Çiftay projesi incelenmelidir. Mikro'daki depolar arası siparişler tablosuna kayıt atılır. 
    
    Gereksinimler
    ---
    fn_Cy_SiparisToplam
    fn_CY_TeklifDegerlendirmeDepoBulma
    fn_CY_TeklifDegerlendirmeTalepNoBulma
    fn_DepoIsmi
    fn_Cy_SiparisToplam
    ---
    Orijinal Proje : Çiftay

**Mikro Çiftay Meyer Sicil Kaydetme-Güncelleme**

    Meyer programı Çiftay'da personel ve özlük yönetimi için kullanılan programdır. Octopod tablolarından istenen personel Meyer'e aktarılmaktadır. 

    Gereksinimler
    ---
    fn_M_YeniMeyerSicilUserID
    ---

    Orijinal Proje : Çiftay

**Mikro-ENQ Yeni Kullanıcı**

    Octopod'da oluşturulan Cari Adresleri Mikro'ya aktarılmaktadır. 
    
    Orijinal Proje : MCM

**Mikro-Timfog Cari Hesaplar Insert**

    Cari tanıtım kartından bilgileri alıp Mikro'ya aktarır. 

    Gereksinimler
    ---
    fn_XP_MikroCariKoduOlusturma_YurtIci
    fn_XP_MikroCariKoduOlusturma_YurtDisi
    ---
    Orijinal Proje : MCM

**Mikro-Timfog Projeler Insert**

    Proje tanıtım kartından bilgileri alıp Mikro'ya aktarır. 

    Gereksinimler
    ---
    fn_XP_MikroProjeKoduOlusturma
    ---
    Orijinal Proje : MCM

**Sayim Giris Fisi**

    Stok kodu ve Depo kodu verilmiş bir sayımı Mikro'daki Sayım Sonuçları tablosuna aktarır.

    Gereksinimler
    ----
    fn_DatePart
    fn_NK_CARI_KODU
    fn_FirmaAlternatifDovizKuru
    ---
    Orijinal Proje : Nikel

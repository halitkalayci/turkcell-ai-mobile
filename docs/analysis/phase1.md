# Ürün – Kategori Modülü  
## Mini E-Ticaret Sistemi – İş Analizi Raporu

**Teknoloji Bağlamı:**  
- Backend: Java Spring  
- Frontend (Mobil): Flutter  

> Bu doküman, mini e-ticaret sisteminde Ürün ve Kategori modülünün işlevsel analizini içerir.  
> Amaç; geliştirme öncesi net iş kuralları, kapsam ve kullanım senaryolarının tanımlanmasıdır.

---

## 1. Amaç (Business Goal)

Bu modülün amacı:

- Ürünlerin anlamlı kategoriler altında organize edilmesini sağlamak  
- Mobil kullanıcıların ürünleri kolayca keşfedebilmesini sağlamak  
- Yönetim tarafında sade ve kontrollü ürün/kategori yönetimi sunmak  
- İleride genişletilebilecek sağlam bir temel oluşturmaktır  

---

## 2. Kapsam (Scope)

### 2.1 Kapsam Dahilinde
- Kategori oluşturma, güncelleme, pasif hale getirme
- Ürün oluşturma, güncelleme, pasif hale getirme
- Ürün – kategori ilişkisi
- Mobil uygulamada kategoriye göre ürün listeleme
- Aktif / pasif yönetimi

### 2.2 Kapsam Dışında (Bu Faz)
- Stok yönetimi
- Kampanya / indirim / kupon
- Ürün varyantları (renk, beden vb.)
- Çoklu dil (i18n)

---

## 3. Aktörler (Actors)

| Aktör | Açıklama |
|---|---|
| Admin | Ürün ve kategori yönetimini yapar |
| Mobil Kullanıcı (Müşteri) | Ürünleri listeler ve inceler |
| Sistem | İş kurallarını ve validasyonları uygular |

---

## 4. Kategori Yönetimi

### 4.1 Kategori Tanımı

Kategori; ürünleri mantıksal olarak gruplamak için kullanılan yapıdır.  
Kategori yapısı **hiyerarşik** olabilir (ana kategori – alt kategori).

---

### 4.2 Kategori Veri Alanları

| Alan | Açıklama |
|---|---|
| Kategori ID | Benzersiz sistem kimliği |
| Ad | Kategori adı |
| Açıklama | Opsiyonel açıklama |
| Parent Kategori ID | Üst kategori (opsiyonel) |
| Sıralama | Mobil listede gösterim sırası |
| Aktif Mi | Kategorinin kullanılabilirliği |
| Oluşturma Tarihi | Audit amaçlı |

---

### 4.3 İş Kuralları – Kategori

1. Aynı parent kategori altında kategori adı benzersiz olmalıdır  
2. Pasif kategori:
   - Mobil uygulamada listelenmez
   - Alt kategorileri de pasif kabul edilir  
3. Üzerinde ürün bulunan kategori silinemez
   - Bunun yerine pasif hale getirilir  
4. Parent kategori pasif ise:
   - Alt kategori aktif olamaz  

---

### 4.4 Kullanım Senaryoları – Kategori

#### UC-01: Kategori Oluşturma (Admin)
- Admin kategori bilgilerini girer
- Sistem benzersizlik ve parent kategori kontrolü yapar
- Kategori kaydedilir

#### UC-02: Kategori Listeleme (Mobil)
- Sadece aktif kategoriler listelenir
- Sıralama alanına göre gösterilir

---

## 5. Ürün Yönetimi

### 5.1 Ürün Tanımı

Ürün; mobil uygulamada listelenen ve kullanıcıya sunulan satılabilir varlıktır.

---

### 5.2 Ürün Veri Alanları

| Alan | Açıklama |
|---|---|
| Ürün ID | Benzersiz sistem kimliği |
| Ad | Ürün adı |
| Açıklama | Ürün detay açıklaması |
| Fiyat | Güncel satış fiyatı |
| Kategori ID | Bağlı olduğu kategori |
| Görsel URL | Ana ürün görseli |
| Aktif Mi | Satışta mı |
| Oluşturma Tarihi | Audit amaçlı |

---

### 5.3 İş Kuralları – Ürün

1. Ürün yalnızca **aktif bir kategoriye** bağlanabilir  
2. Pasif ürün:
   - Mobilde listelenmez
   - Ürün detay ekranı açılmaz  
3. Ürün fiyatı:
   - Negatif olamaz  
4. (Opsiyonel) Aynı kategori altında ürün adı benzersiz olabilir  
5. Ürünün en az bir görseli olması tercih edilir  

---

### 5.4 Kullanım Senaryoları – Ürün

#### UC-03: Ürün Oluşturma (Admin)
- Admin ürün bilgilerini girer
- Sistem kategori aktif mi kontrol eder
- Ürün kaydedilir

#### UC-04: Ürün Listeleme (Mobil)
- Seçilen kategoriye ait ürünler listelenir
- Sadece aktif ürünler gösterilir
- Varsayılan sıralama: en son eklenenler

#### UC-05: Ürün Detayı (Mobil)
- Ürün detay bilgileri gösterilir
- Pasif ürün için erişim engellenir

---

## 6. Ürün – Kategori İlişkisi

- İlişki tipi: **1 Kategori → N Ürün**
- Ürün yalnızca **tek bir kategoriye** bağlıdır

**Gerekçe:**
- Mini e-ticaret için sade yapı
- Daha basit mobil kullanıcı deneyimi
- Yönetimsel karmaşıklığın azaltılması

---

## 7. Mobil (Flutter) Perspektifi – BA Notları

- Kategori listesi cache’lenebilir
- Ürün listeleri pagination veya infinite scroll ile gösterilmelidir
- Empty state senaryoları ele alınmalıdır:
  - Kategoride ürün yok
  - Kategori bulunamadı

---

## 8. Backend (Spring) Perspektifi – BA Notları

- Ürün ve kategori ayrı domain yapıları olarak ele alınabilir
- Silme işlemleri yerine aktif/pasif yaklaşımı tercih edilmelidir
- Mobil performans için listeleme endpoint’leri sade tutulmalıdır
- İş kuralları backend tarafında enforce edilmelidir

---

## 9. Riskler ve Açık Noktalar

| Risk | Açıklama |
|---|---|
| Kategori derinliği | Çok fazla seviye UX’i zorlaştırabilir |
| Pasif veri yönetimi | Admin tarafında karışıklık yaratabilir |
| Tek kategori kuralı | İleride esneklik ihtiyacı doğabilir |

---

## 10. İleride Genişletilebilir Alanlar

- Çoklu kategori desteği
- Ürün varyantları
- Kampanya ve etiketleme
- Arama ve öneri sistemleri

---

## Özet

Bu doküman, ürün ve kategori modülünün sade, yönetilebilir ve mobil öncelikli bir şekilde kurgulanmasını hedefler.  
Amaç; karmaşık e-ticaret yapılarına girmeden, sağlam bir çekirdek oluşturmaktır.

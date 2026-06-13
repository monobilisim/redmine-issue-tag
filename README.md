# Redmine Issue Tag (Mentions)

Etiketlendiğiniz (mention edildiğiniz) yorumları tek bir sayfada, tarih ve proje
filtreleriyle listeleyen Redmine 6 eklentisi.

## Özellikler

- Üst menüde **"Etiketlendiğim Yorumlar"** linki.
- Redmine'ın native `@login` mention sözdizimini journal (yorum) metinlerinde tespit eder.
- Görünürlük (issue ACL + private notes) Redmine'ın `Journal.visible` mantığıyla korunur.
- Alıntı / kod bloğu içindeki mention'lar da sayılır ("nerede etiketlendim" görünümü için).

## Filtreleme & Performans

- **Varsayılan pencere: dün + bugün.** Açılışta tüm veritabanını taramaz; sadece
  son 2 günün journal'larını çeker — bu sayede sayfa hızlı açılır.
- Filtre formu ile:
  - **Tarih aralığı** (From / To)
  - **Proje** seçimi
  - **Uygula** / **Temizle**
- Tarih ve proje filtreleri SQL seviyesinde uygulanır; kriter verildiğinde yalnızca
  o kritere uyan kayıtlar çekilir.

## Kurulum

```bash
cp -r redmine_issue_tag /opt/redmine/plugins/
cd /opt/redmine
# (DB migration gerekmez — tablo kullanılmaz)
systemctl restart puma.service   # veya kullandığınız app server
```

## Yapı

```
redmine_issue_tag/
├── app/
│   ├── controllers/mentions_controller.rb
│   └── views/mentions/index.html.erb
├── config/
│   ├── locales/{tr,en}.yml
│   └── routes.rb
├── lib/redmine_issue_tag/patches/journal_patch.rb
└── init.rb
```

## Gereksinimler

- Redmine 6.0.0+

## Lisans

GPL-2.0 (Redmine ile uyumlu)

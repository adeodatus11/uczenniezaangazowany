# Dokumentacja projektu: platforma samoszkoleniowa `samoszkolenie.html`

> Dokument dla następnego agenta / kontynuatora pracy. Opisuje cały proces budowy, decyzje architektoniczne, zawartość i stan na dzień zakończenia prac.

---

## 1. Co to jest i po co powstało

Jednoplikowa platforma e-learningowa dla nauczycieli szkół zawodowych i techników, zbudowana jako **samodzielny plik HTML** (bez backendu, bez zewnętrznych zależności poza kilkoma CDN). Cel: nauczyciele otwierają plik lokalnie lub hostują na prostym serwerze i przechodzą przez 7 modułów szkoleniowych (~3,5h) poświęconych pracy z uczniami o niskiej motywacji.

Docelowa grupa: nauczyciele **Branżowych Szkół I stopnia (BS1)** i **Technikum**. BS1 to szczególna grupa — uczniowie często z rodzin z niskim kapitałem kulturowym, 2/3 ma obniżone rozumienie tekstu (dane PISA 2022: 394 pkt vs 524 dla LO).

---

## 2. Etapy budowy

### Etap 1 — Badania i strategia (sesje poprzednie)
- Research naukowy: dane PISA 2022, GUS, OKE, Barometr Zawodów
- Teorie pedagogiczne: self-efficacy (Bandura), growth mindset (Dweck), SDT (Deci & Ryan), zasada postępu (Amabile), Visible Learning (Hattie)
- Pliki wyjściowe: `00_strategia_wdrozeniowa.md`, `01_program_szkolenia.md`, `02_scenariusze_warsztatow.md`, `03_narzedzia_dla_nauczycieli.md`, `04_argumenty_i_bibliografia.md`

### Etap 2 — Budowa platformy HTML (m0–m6)
- Zbudowano `samoszkolenie.html` z modułami m0–m6
- Sidebar z postępem (localStorage), quiz system, ćwiczenia z textarea, nawigacja
- CSS custom properties, responsive grid, hamburger menu na mobile

### Etap 3 — Bank Praktyk (moduł m7)
- Zaprojektowano i zaimplementowano 46 kart dobrych praktyk (BP)
- Filtrowanie wg przedmiotu i techniki, licznik wyników
- Podział: 11 humanistyka, 5 matematyka, 7 przyrodnicze, 3 informatyka, 3 geografia, 11 zawodowe, 6 ponadprzedmiotowe
- Techniki: 22 sens, 9 mikrocele, 6 skuteczność, 9 aktywizacja
- Rozwijane karty z krokami, cytatem, efektami, pułapkami

### Etap 4 — Audyt i nowe przykłady
- Audyt 28 istniejących przykładów: zbyt mało przykładów BS1, brak zawodów popularnych (logistyka, hotelarstwo, sprzedaż), brak odniesień do egzaminów zawodowych
- Dodano 18 nowych przykładów zakotwiczonych w polskich realiach: egzamin EE.08 (zdawalność 12,5%), Technikum logistyczne, hotelarstwo (TripAdvisor), sprzedaż (efekt lewej cyfry), fryzjerstwo (utleniacz), gastronomia (fermentacja), budownictwo (kosztorysy), BHP (dane wypadkowe GUS), i in.
- Łącznie: **46 kart BP**

### Etap 5 — Naprawa designu
- Problem: `--card` i `--muted` nie były zdefiniowane w `:root` → karty miały przezroczyste tło
- Dodano aliasy: `--card: var(--white)`, `--muted: var(--text-light)`
- Dodano `word-break: break-word; overflow-wrap: break-word; min-width: 0` na `.bp-card` — tekst wychodził poza granice kart
- Naprawiono `bp-grid`: `minmax(min(340px, 100%), 1fr)` zamiast `minmax(340px, 1fr)` — na wąskich ekranach karty nie wychodziły poza viewport
- Rozszerzono `@media(max-width:768px)` o: `.mod-nav` flex-column, `.inner` max-width:100%, `.keyfact`, `.exercise`, `.quiz`, tabele, welcome
- Dodano pełny `@media(max-width:600px)` dla BP filtrów i kart

### Etap 6 — Biblioteka zasobów (materiały rozszerzające)
- W każdym module m0–m6 dodano sekcję „Materiały rozszerzające" tuż przed przyciskami nawigacji
- 18 filmów (2–4 per moduł) + 3 artykuły per moduł
- Filmy ładują się leniwie (iframe tworzony dopiero po kliknięciu play)
- YouTube: format `youtube-nocookie.com/embed/`, TED: format `embed.ted.com/talks/`

---

## 3. Architektura techniczna `samoszkolenie.html`

### Struktura pliku
```
samoszkolenie.html (~274 KB, 3277 linii)
├── <head>
│   ├── <style> — cały CSS (≈250 linii)
│   └── meta, title, viewport
├── <body>
│   ├── .hamburger — przycisk menu mobile
│   ├── .app
│   │   ├── .sidebar — nawigacja z postępem
│   │   └── .content
│   │       ├── #page-home — strona startowa
│   │       ├── #page-m0 … #page-m6 — moduły
│   │       ├── #page-m7 — Bank Praktyk
│   │       └── #page-finish — strona końcowa
│   └── <script> — cały JS
```

### CSS — custom properties w `:root`
```css
--bg: #f8f7f4          /* tło strony */
--white: #ffffff
--text: #1a1a2e        /* tekst główny */
--text-light: #5a6478  /* tekst muted */
--accent: #2563eb      /* kolor akcji (niebieski) */
--accent-light: #dbeafe
--accent-dark: #1d4ed8
--green: #16a34a
--green-light: #dcfce7
--orange: #ea580c
--purple: #7c3aed
--border: #e2e8f0
--shadow: ...
--r: 10px              /* border-radius */
--card: var(--white)   /* DODANE — aliasy dla BP */
--muted: var(--text-light)
```

### JavaScript — główne funkcje
| Funkcja | Co robi |
|---|---|
| `showPage(id)` | Przełącza widoczny panel (klasa `.active`), aktualizuje sidebar |
| `completeAndNext(current, next)` | Oznacza moduł jako ukończony w localStorage, przechodzi do następnego |
| `updateSidebar()` | Odświeża klasy `.done` / `.active` i pasek postępu |
| `checkQuiz(moduleId)` | Sprawdza odpowiedzi quizu, wyświetla feedback, oblicza wynik |
| `applyFilters()` | Filtruje karty BP wg `data-group` i `data-technique`, aktualizuje licznik |
| `toggleResourceEmbed(btn)` | Lazy-load: tworzy iframe z URL z `data-embed`, ukrywa thumbnail |
| `toggleSidebar()` | Hamburger menu na mobile |

### localStorage — klucze
```javascript
`samoszkolenie_done_${moduleId}` → "true"  // ukończone moduły
```

### MODULES array
```javascript
const MODULES = ['m0','m1','m2','m3','m4','m5','m6','m7'];
```

---

## 4. Zawartość modułów

### m0 — Skąd pochodzi dzisiejszy uczeń? (~30 min)
Tło pokoleniowe: smartfony od 2012, PISA 2022, mózg nastolatka, dane o zdrowiu psychicznym GenZ. Statystyki: 42% nastolatków z objawami depresji (po pandemii). Ćwiczenie: kto jest w twojej klasie?

### m1 — Współczesny uczeń zawodowy (~30 min)
Specyfika BS1 vs Technikum. Dane: zdawalność egzaminów zawodowych (EE.08: 12,5–34%), Barometr Zawodów, system 32 branż / 226 zawodów. Profil ucznia: rozumienie tekstu, środowisko domowe, rynek pracy.

### m2 — Mechanika motywacji (~30 min)
Teoria SDT (Deci & Ryan): autonomia, kompetencja, relacja. Dan Pink: Drive. Extrinsic vs intrinsic. Ćwiczenie: analiza własnej lekcji pod kątem motywatorów.

### m3 — Skuteczność własna (~30 min)
Bandura — self-efficacy. Dweck — growth mindset. Jak budować poczucie skuteczności u uczniów z historią porażek. Techniki: mastery experiences, vicarious learning.

### m4 — Mikrocele i poczucie postępu (~30 min)
Amabile — Progress Principle. BJ Fogg — Tiny Habits. Projektowanie lekcji jako sekwencji małych, osiągalnych kroków. Tablica kroków, checkpoint po każdym etapie.

### m5 — Sens uczenia się (~30 min)
Sinek — Start with Why. Jak łączyć temat z zawodem i życiem. Szablon: „W pracy [zawód] zdarza się, że [sytuacja]. Właśnie po to jest dzisiejszy temat."

### m6 — Relacja i aktywizacja (~30 min)
Hattie — Visible Learning: relacja nauczyciel–uczeń jako jeden z najsilniejszych predyktorów wyników. Rita Pierson — every kid needs a champion. Techniki aktywizacji: Think-Pair-Share, exit tickets, peer teaching.

### m7 — Bank Praktyk (bez limitu czasu)
Filtrowalna galeria 46 kart dobrych praktyk. Każda karta: przedmiot + poziom + problem + rozwijana sekcja z krokami, cytatem, efektami, pułapkami.

---

## 5. Bank Praktyk — szczegóły

### Struktura karty HTML
```html
<div class="bp-card" data-group="[group]" data-technique="[technique]">
  <div class="bp-card-header">
    <div class="bp-card-meta">
      <span class="bp-subject">Przedmiot (BS1/Technikum)</span>
      <span class="bp-technique" style="background:[color]">Technika</span>
    </div>
    <h3 class="bp-title">Tytuł praktyki</h3>
    <div class="bp-level">Poziom: BS1/T • Temat: <em>Temat lekcji</em></div>
  </div>
  <div class="bp-body">
    <p class="bp-problem">Problem: opis sytuacji…</p>
    <details class="bp-details">
      <summary>Rozwiń: kroki, cytat, efekty i pułapki</summary>
      <ol class="bp-steps">…</ol>
      <blockquote class="bp-quote">„…"</blockquote>
      <p class="bp-effect">Efekty: …</p>
      <ul class="bp-traps">…</ul>
    </details>
  </div>
</div>
```

### Grupy przedmiotowe (`data-group`)
- `humanistyka` — j. polski, historia, WOS, j. angielski (11 kart)
- `matematyka` (5 kart)
- `przyrodnicze` — fizyka, chemia, biologia (7 kart)
- `informatyka` (3 karty)
- `geografia` (3 karty)
- `zawodowe` — logistyka, hotelarstwo, sprzedaż, elektryka, gastronomia, fryzjerstwo, budownictwo, BHP, mechanik (11 kart)
- `ponadprzedmiotowe` — CV, przedsiębiorczość, kompetencje miękkie (6 kart)

### Techniki (`data-technique`)
- `sens` — budowanie sensu i relevance (22 karty)
- `mikrocele` — rozbijanie na małe kroki (9 kart)
- `skutecznosc` — budowanie self-efficacy (6 kart)
- `aktywizacja` — metody aktywne, peer learning (9 kart)

---

## 6. Biblioteka zasobów rozszerzających

Każdy moduł m0–m6 ma sekcję tuż przed przyciskiem „Ukończ moduł" z filmami i artykułami.

### Struktura HTML sekcji
```html
<div class="resource-section">
  <div class="resource-section-title">Materiały rozszerzające</div>
  <div class="resource-grid">
    <!-- resource-card × N -->
  </div>
  <div class="resource-articles">
    <div class="resource-articles-title">📄 Artykuły i raporty</div>
    <!-- resource-article-link × 3 -->
  </div>
</div>
```

### Mechanizm lazy-load iframe
```javascript
function toggleResourceEmbed(btn) {
  var wrap = btn.nextElementSibling; // .resource-iframe-wrap
  if (wrap.classList.contains('open')) {
    wrap.classList.remove('open');
    wrap.innerHTML = '';
    btn.style.display = '';
  } else {
    var url = btn.dataset.embed; // YT nocookie lub TED embed URL
    wrap.innerHTML = '<iframe src="' + url + '" frameborder="0" allow="autoplay; fullscreen" allowfullscreen loading="lazy"></iframe>';
    wrap.classList.add('open');
    btn.style.display = 'none';
  }
}
```

### Filmy per moduł

| Moduł | Filmy |
|---|---|
| m0 — Gen Z | Jonathan Haidt TED (ekrany ukradły dzieciństwo), Simon Sinek YT (milenialsi), Nauka to lubię: Czemu młodzież nas irytuje? |
| m1 — Uczeń zawodowy | prof. Pyzalski YT (kim jest uczeń), prof. Pyzalski YT (czarne owce), Nauka to lubię: Dojrzały mózg?, prof. Kaczmarzyk: Co stres robi z mózgiem? |
| m2 — Motywacja | RSA Animate / Dan Pink YT (Drive), Teresa Amabile TEDx (Progress Principle) |
| m3 — Self-efficacy | Carol Dweck TED (growth mindset), BJ Fogg TEDx (tiny habits) |
| m4 — Mikrocele | Teresa Amabile TEDx (Progress Principle), BJ Fogg TEDx (tiny habits) |
| m5 — Sens | Simon Sinek TED (Start with Why), TEDxPoznań Dziadkiewicz (sens w pracy) |
| m6 — Relacja | Rita Pierson TED (every kid needs a champion), Szczepanik YT (metody aktywizujące) |

### Formaty URL embedowania
- YouTube: `https://www.youtube-nocookie.com/embed/{VIDEO_ID}?rel=0&modestbranding=1`
- TED: `https://embed.ted.com/talks/{TALK_SLUG}`
- Miniatury: `https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg`

### YouTube Video IDs (potwierdzono przez wyszukiwanie)
```
hER0Qp6QJNU  — Simon Sinek, Millennials in the workplace
zCWK-B8W9VQ  — prof. Pyzalski, Kim jest dzisiejszy uczeń (90 min)
aX6QD8tgEdQ  — prof. Pyzalski, Czarne owce (60 min)
achUxyRflYc  — Nauka to lubię, Czemu młodzież nas irytuje? (Kaczmarzyk)
mkja6wXXGpo  — Nauka to lubię, Dojrzały mózg? (Kaczmarzyk)
sGY0ouOt3u0  — prof. Kaczmarzyk, Co stres robi z twoim mózgiem?
u6XAPnuFjJc  — RSA Animate, Dan Pink Drive
XD6N8bsjOEE  — Teresa Amabile TEDx, Progress Principle
AdKUJxjn-R8  — BJ Fogg TEDx, Tiny Habits
-ZNXo_CJlLo  — TEDxPoznań Dziadkiewicz, Sens w pracy
2koKRrI_v8c  — Szczepanik, Metody aktywizujące
```

### TED Talk Slugs
```
jonathan_haidt_how_screens_stole_childhood_and_how_to_get_it_back
carol_dweck_the_power_of_believing_that_you_can_improve
simon_sinek_how_great_leaders_inspire_action
rita_pierson_every_kid_needs_a_champion
```

---

## 7. Inne pliki w katalogu

| Plik | Opis |
|---|---|
| `samoszkolenie.html` | Główna platforma (ten plik) |
| `program_szkoleniowy.html` | Starsza wersja programu szkoleniowego (HTML, nie e-learning) |
| `00_strategia_wdrozeniowa.md` | Pełna strategia wdrożenia programu w szkole |
| `01_program_szkolenia.md` | Program szkolenia 8–16h ze szczegółowymi scenariuszami |
| `02_scenariusze_warsztatow.md` | Gotowe scenariusze warsztatów do przeprowadzenia z nauczycielami |
| `03_narzedzia_dla_nauczycieli.md` | Zestaw gotowych narzędzi (szablony, karty, listy) |
| `04_argumenty_i_bibliografia.md` | Argumenty dla sceptyków + pełna bibliografia naukowa |
| `_materialy_zrodlowe/` | Materiały źródłowe zebrane podczas research |

---

## 8. Decyzje architektoniczne — dlaczego tak

**Jeden plik HTML bez backendu** — nauczyciele mogą otworzyć plik lokalnie, przesłać mailem, hostować na każdym serwerze. Zero zależności od infrastruktury szkoły.

**localStorage zamiast serwera** — postęp zapisywany lokalnie w przeglądarce. Wystarczy dla indywidualnego użytku, nie wymaga logowania.

**Python injection zamiast pełnego przepisania** — moduły były dodawane etapami przez Python string injection (replace na unikalnych kotwicach). Pozwoliło to na bezpieczne poszerzanie pliku bez ryzyka utraty istniejącej zawartości.

**CSS custom properties** — umożliwiają łatwą zmianę motywu kolorystycznego. Wszystkie kolory przez zmienne, zero hardkodowanych wartości w komponentach.

**data-embed + lazy iframe** — filmy wczytują się dopiero po kliknięciu play. Strona ładuje się szybko nawet z 18 potencjalnymi iframe'ami.

---

## 9. Znane problemy i ograniczenia

- **TED embed slugs** — nie wszystkie są w 100% zweryfikowane. Jeśli film TED się nie ładuje, sprawdź slug na `embed.ted.com`.
- **Video ID `-ZNXo_CJlLo`** (Dziadkiewicz TEDxPoznań) — zaczyna się od myślnika, co jest poprawnym YouTube ID, ale niektóre parsery mogą mieć z tym problem.
- **Brak quizów w m7** — Bank Praktyk nie ma interakcji quizowej; celowo, to zasób do przeglądania.
- **localStorage na iOS Safari** — Private Browsing blokuje localStorage; postęp nie będzie zapisywany w trybie prywatnym.
- **Brak Wyżga/Didaskalia o nastolatkach** — wyszukiwanie nie znalazło odcinka didaskaliów stricte o nastolatku w szkole. Kanał Wyżgi jest polityczno-społeczny. Najbliższe: prof. Kaczmarzyk w innym kontekście.

---

## 10. Sugestie na kolejne etapy

- **Quizy w m7** — krótki quiz „dopasuj problem do techniki" jako interaktywny element
- **Eksport postępu** — przycisk „pobierz certyfikat" generujący PDF z przebiegu
- **Wersja offline PWA** — Service Worker dla pełnej offline obsługi
- **Komentarze i notatki** — textarea z localStorage per BP card, żeby nauczyciel zapisał własne przemyślenia
- **Filtrowanie po poziomie** (BS1 / Technikum) — aktualnie nie ma takiego filtru, ale `bp-level` ma tę informację
- **Więcej kart zawodowych** — brakuje: informatyk, elektryk/automatyk, mechanik samochodowy, opiekun
- **Wersja drukowana** — `@media print` CSS dla wybranych kart BP

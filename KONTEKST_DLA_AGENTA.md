# Kontekst dla następnego agenta

> Krótki brief — przeczytaj NAJPIERW TEN PLIK, potem `PROJEKT_DOKUMENTACJA.md` po szczegóły.

---

## Czym jest ten projekt

Jednoplikowa platforma e-learningowa dla nauczycieli szkół zawodowych (`samoszkolenie.html`, 274 KB). Nauczyciel otwiera plik w przeglądarce i przechodzi 7 modułów szkoleniowych o pracy z uczniami o niskiej motywacji.

Lokalizacja pliku: `program-szkoleniowy-nauczyciele/samoszkolenie.html`

---

## Co zostało już ZROBIONE (nie powtarzaj)

### Struktura HTML
- Moduły m0–m6 (6 modułów merytorycznych) + m7 (Bank Praktyk) + strona home i finish
- Sidebar z postępem (localStorage), quizy, ćwiczenia z textarea, nawigacja

### Moduły merytoryczne (m0–m6)
Każdy moduł zawiera: wstęp z danymi, keyfact, statystyki, sekcje z treścią, callouts (niebieski/zielony/pomarańczowy/fioletowy), ćwiczenie, quiz, takeaway.

Tematy modułów:
- m0: Tło pokoleniowe (GenZ, smartfony, PISA 2022)
- m1: Współczesny uczeń zawodowy (BS1 vs T, egzaminy zawodowe)
- m2: Mechanika motywacji (SDT, Dan Pink)
- m3: Self-efficacy (Bandura, Dweck)
- m4: Mikrocele i postęp (Amabile, BJ Fogg)
- m5: Sens uczenia się (Sinek, Start with Why)
- m6: Relacja i aktywizacja (Hattie, Rita Pierson)

### Bank Praktyk (m7)
46 kart dobrych praktyk z filtrowaniem. Przedmioty: humanistyka (11), zawodowe (11), przyrodnicze (7), matematyka (5), ponadprzedmiotowe (6), informatyka (3), geografia (3). Techniki: sens (22), mikrocele (9), aktywizacja (9), skuteczność (6).

### Biblioteka zasobów rozszerzających
W każdym module m0–m6 jest sekcja „Materiały rozszerzające" z filmami (lazy-load iframe) i artykułami. Łącznie 18 filmów (YT + TED) + ~21 artykułów.

### Design fixes
- Naprawione zmienne CSS (`--card`, `--muted`)
- `word-break: break-word` na kartach BP
- Mobile layout (hamburger, sidebar, responsive grid)

---

## Stan kodu — ważne szczegóły techniczne

### Jak dodać nowe karty BP
Wstrzyknij HTML przed znacznikiem `<div class="section-nav">` w sekcji m7. Użyj struktury:
```html
<div class="bp-card" data-group="GRUPA" data-technique="TECHNIKA">
  <!-- bp-card-header, bp-body, bp-details -->
</div>
```
Grupy: `humanistyka` `matematyka` `przyrodnicze` `informatyka` `geografia` `zawodowe` `ponadprzedmiotowe`
Techniki: `sens` `mikrocele` `skutecznosc` `aktywizacja`

**Pamiętaj:** po dodaniu kart zaktualizuj licznik `total` w JS:
```javascript
var total = 46; // zmień na nową liczbę
```

### Jak dodać nowe filmy do sekcji zasobów
Każda sekcja zasobów jest między `takeaway` a `mod-nav` w danym module. Dodaj kartę wewnątrz `.resource-grid`:
```html
<div class="resource-card">
  <button class="resource-embed-toggle" onclick="toggleResourceEmbed(this)" 
          data-embed="https://www.youtube-nocookie.com/embed/VIDEO_ID?rel=0&modestbranding=1">
    <div class="resource-thumb" style="background-image:url('https://img.youtube.com/vi/VIDEO_ID/hqdefault.jpg')">
      <div class="resource-thumb-overlay">
        <div class="resource-play"><svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg></div>
      </div>
    </div>
  </button>
  <div class="resource-iframe-wrap" id="embed-UNIKALNY_ID"></div>
  <div class="resource-info">
    <div class="resource-info-meta">YouTube • Autor • czas</div>
    <div class="resource-info-title">Tytuł</div>
    <div class="resource-info-desc">Opis.</div>
  </div>
</div>
```

### Jak zmodyfikować moduł merytoryczny
Każdy moduł to `<div class="page" id="page-mX">` … `</div>`. Komponenty CSS:
- `.keyfact` — granatowe pole z kluczowym faktem/danymi
- `.stats` — siatka kafelków ze statystykami
- `.callout.blue/.green/.orange/.purple` — kolorowe ramki na uwagi
- `.exercise` — pole z ćwiczeniem i textarea
- `.quiz` — interaktywny quiz (funkcja `checkQuiz`)
- `.takeaway` — zielone podsumowanie modułu
- `.mod-nav` — przyciski nawigacji

### Kolejność modułów (flow)
```
home → m0 → m1 → m2 → m3 → m4 → m5 → m6 → m7 (Bank Praktyk) → finish
```
Sterowanie przez `completeAndNext('mX','mY')`.

---

## Kluczowe dane używane w treści

- PISA 2022: uczniowie BS1 → 394 pkt (vs 524 dla LO), 2/3 ma obniżone rozumienie tekstu
- EE.08 (sieci komputerowe): zdawalność 12,5–34% (dane OKE)
- System: 226 zawodów w 32 branżach (CKE)
- Barometr Zawodów 2024: logistyk, sprzedawca, kucharz w TOP niedoborów
- Bandura self-efficacy: 4 źródła — mastery experiences, vicarious learning, verbal persuasion, physiological states
- Amabile Progress Principle: drobny postęp w sensownej pracy = najsilniejszy motywator wewnętrzny
- Hattie Visible Learning: relacja nauczyciel–uczeń d=0.72 (wysoki efekt)

---

## Rzeczy NIEZROBIONE (potencjalne kolejne etapy)

1. **Filtr BS1/Technikum** w Bank Praktyk — dane są w `bp-level`, brak filtru w UI
2. **Eksport/certyfikat** — przycisk po ukończeniu generujący PDF
3. **Notatki per karta BP** — textarea z localStorage dla każdej karty
4. **PWA/Service Worker** — pełna offline obsługa
5. **Więcej kart zawodowych** — brakuje: informatyk, elektryk/automatyk, mechanik samochodowy, opiekun medyczny
6. **Wersja drukowana** — `@media print` dla wybranych kart BP
7. **Tłumaczenie** — część cytatów w kartach po angielsku, można spolszczyć
8. **Wersja dla dyrektora** — streszczenie całego programu na 2 strony A4

---

## Uwagi o jakości treści

Przykłady w Bank Praktyk są zakorzenione w polskich realiach (konkretne zawody, egzaminy, dane rynkowe). Unikaj przykładów abstrakcyjnych typu „klasa 3A miała problem z motywacją" — każda karta powinna mieć: konkretny temat z podstawy programowej, konkretny zawód/poziom, mierzalny efekt.

Cytaty w kartach powinny brzmieć jak autentyczne głosy uczniów lub nauczycieli — nie jak podręcznikowe przykłady.

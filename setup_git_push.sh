#!/bin/bash
# Uruchom w terminalu: bash setup_git_push.sh
# Wymaga: git + Personal Access Token GitHub

set -e
cd "$(dirname "$0")"

echo "→ Czyszczę stare .git (jeśli jest)..."
rm -rf .git

echo "→ Inicjuję repo..."
git init -b main

echo "→ Konfiguram autora..."
git config user.name "Maciek Najwer"
git config user.email "maciejnajwer@gmail.com"

echo "→ Dodaję pliki..."
git add -A

echo "→ Pierwszy commit..."
git commit -m "feat: platforma e-learningowa — wersja 1.0

- index.html: 7 modułów szkoleniowych dla nauczycieli
- Bank Praktyk: 46 kart dobrych praktyk z filtrowaniem
- Biblioteka materiałów: 17 filmów YT/TED + artykuły
- Responsywny design, quizy, progress bar w localStorage
- Logotypy COVE Polska / UE w stopce"

echo "→ Ustawiam remote..."
git remote add origin https://github.com/adeodatus11/uczenniezaangazowany.git

echo "→ Pushuję na GitHub..."
echo "   Gdy pyta o hasło — podaj Personal Access Token (nie hasło konta)."
echo "   Token: https://github.com/settings/tokens/new  (zakres: repo)"
git push -u origin main

echo ""
echo "✅ Gotowe!"
echo ""
echo "Włącz GitHub Pages:"
echo "  → https://github.com/adeodatus11/uczenniezaangazowany/settings/pages"
echo "  → Source: Deploy from branch → main → / (root) → Save"
echo ""
echo "Strona będzie dostępna pod:"
echo "  https://adeodatus11.github.io/uczenniezaangazowany/"

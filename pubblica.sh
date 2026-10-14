#!/bin/bash
# Pubblica una nuova versione di PC Booster dal Mac.
# GitHub crea l'exe per Windows nel cloud e tutti i PC si aggiornano da soli.
# Serve: GitHub CLI (gh) collegato al tuo account con "gh auth login".
cd "$(dirname "$0")" || exit 1

if ! command -v gh >/dev/null; then echo "GitHub CLI non trovato: installalo con  brew install gh"; exit 1; fi
if ! command -v git >/dev/null; then echo "Git non trovato: scrivi  xcode-select --install  e riprova"; exit 1; fi
if ! gh auth status >/dev/null 2>&1; then echo "Prima collegati a GitHub con:  gh auth login"; exit 1; fi

# ---- Prima volta: crea il repository e carica il codice ----
if [ ! -d .git ]; then
  utente=$(gh api user --jq .login)
  echo "Prima pubblicazione: creo il repository $utente/PCBooster"
  printf '%s' "$utente/PCBooster" > repo.txt
  git init -q -b main
  git config user.name >/dev/null || git config user.name "$utente"
  git config user.email >/dev/null || git config user.email "$utente@users.noreply.github.com"
  git add -A
  git commit -qm "Prima versione"
  if gh repo view "$utente/PCBooster" >/dev/null 2>&1; then
    git remote add origin "https://github.com/$utente/PCBooster.git"
    git push -u origin main --force || { echo "Caricamento non riuscito."; exit 1; }
  else
    gh repo create "$utente/PCBooster" --public --source . --push --description "PC Booster" \
      || { echo "Non riesco a creare il repository."; exit 1; }
  fi
fi

attuale=$(tr -d '[:space:]' < version.txt)
echo "Versione attuale: $attuale"
read -rp "Numero della nuova versione (es. 1.0.1): " nuova
[ -z "$nuova" ] && { echo "Nessuna versione inserita."; exit 1; }
if git rev-parse "v$nuova" >/dev/null 2>&1; then echo "La versione $nuova esiste già: scegline una più alta."; exit 1; fi
read -rp "Cosa cambia in questa versione (una riga): " note
[ -z "$note" ] && note="Miglioramenti vari"

printf '%s' "$nuova" > version.txt
git add -A
git commit -qm "$note" || git commit -q --allow-empty -m "$note"
git tag "v$nuova"
git push -q origin main && git push -q origin "v$nuova" || { echo "Caricamento non riuscito."; exit 1; }

repo=$(tr -d '[:space:]' < repo.txt)
echo
echo "Versione $nuova caricata. GitHub sta creando l'exe (ci vogliono circa 3-5 minuti):"
echo "  https://github.com/$repo/actions"
echo "Quando è pronto lo trovi qui, e i PC si aggiornano da soli al prossimo avvio:"
echo "  https://github.com/$repo/releases"

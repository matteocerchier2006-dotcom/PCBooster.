# PC Booster

App per Windows 10/11 che tiene in forma il PC: driver della scheda video, aggiornamenti di processore/chipset e Windows, pulizia dei file inutili e disinstallazione di app e giochi.

## Cosa fa

| Sezione | Cosa controlla / fa |
|---|---|
| **Panoramica** | Specifiche del PC, uso live di CPU, RAM e disco. **Fai il check-up** controlla tutto e ti dice cosa sistemare. **Ottimizza tutto** applica con un clic le ottimizzazioni per i giochi e toglie dall'avvio i programmi non necessari. |
| **Avvio automatico** | Elenco dei programmi che partono all'accensione, con consigli su cosa spegnere (launcher, Discord, Spotify…) e cosa lasciare (antivirus, audio, driver). Si disattivano come in Gestione attività, quindi si possono riattivare in qualsiasi momento. |
| **Scheda video** | Legge versione e data del driver (NVIDIA, AMD, Intel). Se ha più di 4 mesi lo segnala e apre l'app ufficiale o il sito per scaricare l'ultimo. Interruttori per Modalità Gioco, Pianificazione GPU hardware, piano Prestazioni elevate e registrazione in background della Game Bar. |
| **Processore e aggiornamenti** | Cerca su Windows Update driver video, chipset/processore e aggiornamenti di sistema, e li installa. Link al driver chipset ufficiale (AMD/Intel). |
| **Pulizia** | Analizza temporanei, cache shader di DirectX/NVIDIA/AMD, miniature, vecchi download di Windows Update, report di errore e cestino. Pulisce solo quello che selezioni. |
| **App e giochi** | Elenco di tutto ciò che è installato, dal più pesante. Filtro Giochi/App (riconosce Steam, Epic e i principali editori) e disinstallazione con il programma ufficiale di ogni app. |

## Come avviarla

**Serve Python 3.10 o più recente** (da python.org, spunta *Add Python to PATH* durante l'installazione).

- **Per provarla subito:** doppio clic su `avvia.bat`.
- **Per avere un .exe:** doppio clic su `crea_exe.bat`. Dopo un paio di minuti trovi `PC Booster.exe` nella cartella `dist`: quello lo puoi copiare sul PC di tuo fratello, lì non serve Python.

All'avvio Windows chiede i permessi di amministratore: servono per installare aggiornamenti, cambiare le impostazioni della GPU e pulire le cartelle di sistema. Se rifiuti, l'app parte lo stesso in modalità limitata.

## Aggiornamenti automatici (modifichi una volta, si aggiorna su tutti i PC)

L'app all'avvio controlla su GitHub se hai pubblicato una versione nuova. Se c'è, la scarica, si chiude e si riapre già aggiornata. Si può spegnere da **Impostazioni**.

**Preparazione (una volta sola, sul tuo PC):**
1. Crea un account gratuito su github.com.
2. Installa GitHub CLI da https://cli.github.com.
3. Apri il Prompt dei comandi e scrivi `gh auth login`, poi segui le domande (GitHub.com → HTTPS → accedi col browser).

**Ogni volta che vuoi aggiornare tutti i PC:**
1. Fai le modifiche ai file.
2. Doppio clic su `pubblica.bat`: ti chiede il numero della nuova versione (es. `1.0.1`, deve essere più alto del precedente) e una riga su cosa cambia.
3. Fine: crea l'exe e lo pubblica. Al prossimo avvio, ogni PC si aggiorna da solo.

La prima volta `pubblica.bat` crea da solo il repository `PCBooster` sul tuo GitHub e salva il nome in `repo.txt`. **Importante:** l'exe che installi sui PC deve essere uno creato *dopo* questa prima pubblicazione (prendilo da `dist`), così sa dove cercare gli aggiornamenti. Il repository è pubblico: dentro c'è solo l'exe dell'app, nessun dato tuo.

## Pubblicare dal Mac (consigliato)

Il Mac non può creare l'exe per Windows, quindi lo fa GitHub nel cloud: tu carichi le modifiche, GitHub crea `PCBooster.exe` su un Windows virtuale e lo pubblica. Sui PC Windows non serve Python: basta scaricare l'exe una volta.

**Una volta sola sul Mac:**
1. Installa Homebrew (istruzioni su brew.sh), poi nel Terminale: `brew install gh`
2. Nel Terminale: `gh auth login` e rispondi GitHub.com → HTTPS → **Yes** (autentica Git) → Login with a web browser.

**Ogni volta che vuoi aggiornare:** nel Terminale vai nella cartella (`cd ` e trascina la cartella PCBooster nella finestra, poi Invio) e scrivi `bash pubblica.sh`. Ti chiede versione e descrizione; dopo 3-5 minuti l'exe nuovo è su GitHub e i PC si aggiornano da soli.

Usa un solo metodo (Mac con `pubblica.sh` oppure Windows con `pubblica.bat`), non tutti e due, così le versioni non si confondono.

## Note

- La finestra usa Microsoft Edge WebView2, già presente in Windows 10 e 11.
- Windows Defender a volte segnala gli .exe creati con PyInstaller come "sconosciuti": è normale per i programmi non firmati, scegli *Esegui comunque*.
- La pulizia salta i file in uso (es. temporanei di app aperte): è voluto.
- Le cache shader si ricreano da sole: il primo avvio di un gioco dopo la pulizia può caricare qualche secondo in più.

## File

- `app.py` — apre la finestra
- `backend.py` — tutte le operazioni sul PC (PowerShell, registro, Windows Update)
- `updater.py` — aggiornamento automatico dell'app
- `ui/` — interfaccia (HTML, CSS, JavaScript)
- `version.txt`, `repo.txt` — versione attuale e repository GitHub (li aggiorna `pubblica.bat`)
- `pubblica.bat` — crea e pubblica una nuova versione da Windows
- `pubblica.sh` — pubblica una nuova versione dal Mac (l'exe lo crea GitHub)
- `.github/workflows/pubblica.yml` — istruzioni per GitHub su come creare l'exe

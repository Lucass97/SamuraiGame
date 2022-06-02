# Samurai Game

Un gioco platform a tema samurai sviluppato per piattaforme mobile.
Samurai Game è stato realizzato per il corso di Mobile Computing di Roma Tre (2021/2022).

Autore : *Luca Gregori*

![Spuntoni](docs/demo.gif)

## Wiki
Qui di seguito saranno mostrati i principali aspetti del gioco.
### Obiettivi

| Immagine               | Obiettivo                                        |
|------------------------|--------------------------------------------------|
| ![Coin](docs/coin.gif) | Collezionare le monete sparse per il gioco       |
| ![Skull](docs/skull.gif) | Raccogliore il teschio per concludere il livello |


### Consigli

![Wiki](docs/screenshot1.png "Consigli")

> Esegui un attacco corpo a corpo contro una freccia in arrivo per rimandarla indietro e uccidere l'arciere o qualsiasi nemico che si trova in mezzo.

> Se lasciato indisturbato lo spadaccino con lo scudo non ti attaccherà.


### Nemici

| Immagine                                                              | Entità               | Velocità | Attacco | Difesa | Vita | Descrizione                                                                                                                                                                                                                                                                                                                                                                                                                |
|-----------------------------------------------------------------------|----------------------|----------|---------|--------|------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![Skeleton](docs/skeleton.gif)          | **Scheletro**            | Veloce   | Mischia | No     | 1 HP | Nemico semplice che esegue attacchi in mischia.                                                                                                                                                                                                                                                                                                                                                                            |
| ![Knight](docs/knight.gif)              | **Spadaccino**           | Medio    | Spada   | No     | 2 HP | Nemico che esegue attacchi con la spada.                                                                                                                                                                                                                                                                                                                                                                                   |
| ![Shield](docs/shield.png)              | **Spadaccino** con scudo | Lento    | Spada   | Scudo  | 3 HP | Quando chiude la distanza del giocatore alza in automatico lo scudo per difendersi.<br/>Se si colpisce lo scudo il colpo verrò parato e il nemico contrattaccherà subito dopo.<br/>Se non si dovesse colpire il nemico mentre questo è con lo scudo alzato c'è una buona probabilità che questo esegua un attacco di sua iniziativa.<br/>La probabilità di attacco per iniziativa aumenta man mano che passa il tempo.<br/> |
| ![Archer](docs/archer.gif)              | **Arciere**              | Medio    | Arco    | No     | 2 HP | Appena il giocatore entrerà nel campo visivo dell'arciere quest'ultimo scaglierà una freccia verso lui.<br/>Le frecce possono danneggiare anche gli altri nemici oltre che il giocatore.                                                                                                                                                                                                                                        |
| ![YellowArcher](docs/yellow_archer.gif) | **Arciere Giallo**       | Medio    | Arco    | No     | 2 HP | Si comporta come un arciere normale, tuttavia scocca 5 freccie consecutive in rapida successione come singolo attacco.                                                                                                                                                                                                                                                                                                     |
| ![RedArcher](docs/red_archer.gif)       | **Arciere Rosso**        | Medio    | Arco    | No     | 2 HP | Si comporta come un arciere normale, tuttavia scocca 3 freccie contemporaneamente in un singolo attacco.                                                                                                                                                                                                                                                                                                                   |                                                                                                                                                                                                                                                                                                                                                                                                          |

### Altro

| Immagine                                                            | Descrizione                                           |
|---------------------------------------------------------------------|-------------------------------------------------------|
| ![CircularSaw](docs/circular_saw.png) | Sega circolante in grado di danneggiare il giocatore. |
| ![Spuntoni](docs/spuntoni.png)        | Spuntoni in grado di danneggiare il giocatore.        | 


### Livelli

Al momento sono disponibili due livelli.

![Selezione livello](docs/screenshot3.png "Schermata di selezione del livello")
*Screenshot della schermata di selezione del livello.*

---

![Primo livello](docs/screenshot4.png "Primo livello")
*Screenshot del primo livello.*

---

![Secondo livello](docs/screenshot5.png "Secondo livello")
*Screeshot del secondo livello.*

---


## Installazione
Per installare "Samurai Game" su `android` navigare all'interno di questa repository in `release` e scaricare l'**APK**.
Copiare sul proprio dispositivo il file **APK** e, prima di procedere con l'installazione, assicurarsi di abilitare la funzione: `Installa da origini sconosciute`.
Una volta installato il gioco navigare nelle impostazione per fornire all'applicativo le autorizzazioni di lettura e scrittura di file.
Senza questo passaggio non sarà possibile usufruire delle statistiche in game.

Versione di android testata: 6.0

## Riferimenti

Sviluppato e ideato da _Luca Gregori_.

![Secondo livello](docs/screenshot2.png "Secondo livello")

---

[Link ufficiale a Godot.](https://godotengine.org/)

### Assets utilizzati
- Autore: _[Senari Rey](https://senari-rey.itch.io/)_
- Tipo di licenza: CC BY 4.0
- Reperibili al seguente [link](https://senari-rey.itch.io/pixel-art-platformer-tileset)

### Musica utilizzata
- Titolo: Slave Knight Gael (8-bit)
- Reberibile al seguente [link](https://www.youtube.com/watch?v=JBts5_EPu38)